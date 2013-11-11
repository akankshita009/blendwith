
class MyCommentsController < Opinio::CommentsController
  def create
    @user = User.find(params[:user_id])
    @comment = resource.comments.build(params[:comment])
    @comment.owner = send(Opinio.current_user_method)
    if @comment.save
      User.find(params[:user_id]).new_comment
      flash_area = :notice
      message = t('opinio.messages.comment_sent')
    else
      flash_area = :error
      message = t('opinio.messages.comment_sending_error')
    end

    @reply = true if resource.class == Comment

    respond_to do |format|
      format.js
      format.html do
        set_flash(flash_area, message)
        #redirect_to(opinio_after_create_path(resource))
        redirect_to user_path(params[:user_id])
      end
    end
  end

  def destroy
    render :nothing => true
  end
end