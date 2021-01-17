class MessageCommentsController < ApplicationController
  before_action :set_user

  # POST /messages/:message_id/comments
  def create
    @message = Message.find(params[:message_id])
    @comment = @message.comments.new(comment_params)
    return if @message.save

    @error = true
    flash.now[:error] = "Please submit a comment."
  end

  # DELETE /messages/:message_id/comments/:id
  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @message = Message.find(params[:message_id])
    @comment.destroy

    redirect_to message_path(@message)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :user_id)
  end

  def set_user
    @user = current_user
  end
end
