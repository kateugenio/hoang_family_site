require 'rails_helper'

RSpec.describe "MessageComments", type: :request do
  before {
    @user = create(:user)
    @message = create(:message)
    sign_in @user
  }

  describe '#create' do
    it 'creates successfully' do
      # Arrange
      params = {
        comment: {
          comment: 'nice post!',
          user_id: @user.id
        }
      }
      comments_before = @message.comments.count

      # Act
      post message_comments_path(@message, params: params), xhr: true

      # Assert
      expect(response).to render_template(:create)
      expect(@message.comments.count).to eq comments_before + 1
    end

    it 'flashes error message if unsuccessful' do
      # Arrange
      params = {
        comment: {
          comment: '',
          user_id: @user.id
        }
      }
      comments_before = @message.comments.count

      # Act
      post message_comments_path(@message, params: params), xhr: true

      # Assert
      expect(response).to render_template(:create)
      expect(@message.comments.count).to eq comments_before
      expect(flash[:error]).to include 'Please submit a comment.'
    end
  end

  describe '#destroy' do
    it 'destroys successfully' do
      # Arrange
      comment = create(:message_comment)
      message = comment.commentable
      comments_before = message.comments.count

      # Act
      delete message_comment_destroy_path(message, comment)

      # Assert
      expect(response).to redirect_to(message_path(message))
      expect(message.comments.count).to eq(comments_before - 1)
    end

    it 'does not allow to delete recipe if unauthorized' do
      # Arrange
      comment = create(:message_comment)
      sign_out @user
      other_user = create(:user2)
      sign_in other_user
      message = comment.commentable

      # Act
      delete message_comment_destroy_path(message, comment)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end
end
