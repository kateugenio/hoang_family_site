require 'rails_helper'

RSpec.describe "Messages", type: :request do
  before {
    @user = create(:user)
    sign_in @user
    @message = create(:message)
  }

  it 'renders index' do
    # Act
    get messages_path

    # Assert
    expect(response).to render_template(:index)
  end

  it 'renders new' do
    # Act
    get new_message_path

    # Assert
    expect(response).to render_template(:new)
  end

  it 'renders show' do
    # Act
    get message_path(@message)

    # Assert
    expect(response).to render_template(:show)
  end

  describe '#edit' do
    it 'renders edit' do
      # Act
      get edit_message_path(@message)

      # Assert
      expect(response).to render_template(:edit)
    end

    it 'does not allow to view edit message page if not authorized' do
      # Arrange
      sign_out @user
      user2 = create(:user2)
      sign_in user2

      # Assume
      expect(@message.user).not_to eq(user2)

      # Act
      get edit_message_path(@message)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end

  describe '#create' do
    it 'creates successfully' do
      # Arrange
      params = {
        message: {
          subject: 'Grandma is visiting',
          body: 'Lets plan a big family dinner'
        }
      }
      messages_before = Message.count

      # Act
      post messages_path(params)

      # Assert
      expect(response).to redirect_to(messages_path)
      expect(Message.count).to eq messages_before + 1
    end

    it 'renders flash error if unsuccessful' do
      # Arrange
      params = {
        message: {
          subject: '',
          body: 'Lets plan a big family dinner'
        }
      }
      messages_before = Message.count

      # Act
      post messages_path(params)

      # Assert
      expect(response).to render_template(:new)
      expect(Message.count).to eq messages_before
      expect(flash[:error]).to include 'Subject cannot be blank'
    end
  end

  describe '#update' do
    it 'updates successfuly' do
      # Arrange
      params = { message: { body: 'updated message' } }

      # Act
      patch message_path(@message, params: params)

      # Assert
      expect(response).to redirect_to(messages_path)
      expect(@message.reload.body).to eq('updated message')
    end

    it 'renders flash error if invalid update' do
      # Arrange
      params = { message: { subject: '' } }

      # Act
      patch message_path(@message, params: params)

      # Assert
      expect(response).to render_template(:edit)
      expect(flash[:error]).to include 'Subject cannot be blank'
    end

    it 'does not allow to update message if unauthorized' do
      # Arrange
      message = create(:message2)
      params = { message: { subject: 'new subject' } }

      # Assume
      expect(message.user).not_to eq(@user)

      # Act
      patch message_path(message, params: params)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end

  describe '#destroy' do
    it 'destroys successfully' do
      # Act
      delete message_path(@message)

      # Assert
      expect(response).to redirect_to(messages_path)
    end

    it 'does not allow to delete recipe if unauthorized' do
      # Arrange
      message = create(:message2)

      # Assume
      expect(message.user).not_to eq(@user)

      # Act
      delete message_path(message)

      # Assert
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to include 'You are not authorized to access this page.'
    end
  end
end
