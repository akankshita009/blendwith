class ConversationsController < ApplicationController

  layout 'friend'

  before_filter :authenticate_user!

  skip_before_filter :verify_authenticity_token, :only => [:trash, :untrash, :reply]

  helper_method :mailbox, :conversation

  def index
    @which_box = params[:which_box] || 'inbox'
    if params[:conversation]
      @conversation = Conversation.find(params[:conversation])
      @receipts = @conversation.receipts_for(current_user).order('created_at asc')
    end
  end

  def inbox
    @conversations = mailbox.inbox.page(params[:page]).per(12)
  end

  def sent_box
    @conversations = mailbox.sentbox.page(params[:page]).per(12)
  end

  def trash_box
    @is_trash = true
    @conversations = mailbox.trash.page(params[:page]).per(12)
  end

  def new
    @user = User.find params[:send_to]
  end

  def show
    @conversation = Conversation.find params[:id]
    @receipts = @conversation.receipts_for(current_user).order('created_at asc')
    render :json => {html: render_to_string(:partial => 'conversations/show')}
    @receipts.mark_as_read
  end

  #recipient_emails = conversation_params(:recipients).split(',')
  #recipients = User.where(email
  # : recipient_emails).all
  def create
    user = User.find params[:conversation][:recipients]
    conver = current_user.send_message(user, *conversation_params(:body, :subject)).conversation
    redirect_to "#{conversations_url}?which_box=sent_box&conversation=#{conver.id}"
  end

  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
  end

  def trash
    conversation.move_to_trash(current_user)
  end

  def untrash
    conversation.untrash(current_user)
  end

  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
    @receipts ||= @conversation.receipts_for(current_user).order('created_at asc')
    @conversation
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end
end
