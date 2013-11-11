class FriendMap < ActiveRecord::Base
  # default_scope { joins(:friend).where(users: {deleted_at: nil}) }

  attr_accessible :user_id, :friend_id, :is_confirmed

  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"

  def message_confirm_friends user, fiend
    user_name = !!user.profile ? user.profile.full_name: user.name
    user.send_message("#{user_name} adds you as friend",
                      "#{user_name} adds you as friend<br/>
                      <a href='/friend_maps/confirm_friend?id=#{self.id}&confirm=true' class='click-msg'>Approve</a>
                       or <a href='/friend_maps/confirm_friend?id=#{self.id}confirm=false' class='click-msg'>Reject</a>", fiend)
  end

end
