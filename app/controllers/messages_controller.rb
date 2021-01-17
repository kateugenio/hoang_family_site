class MessagesController < ApplicationController
  before_action :set_user

  # GET /messages
  def index
    @messages = Message.includes(:comments, :user).all.order(created_at: :desc)
  end

  # GET /messages/new
  def new
    @message = @user.messages.new
  end

  # GET /messages/:id
  def show
    @message = Message.includes(:comments, :user).find(params[:id])
  end

  # GET /messages/:id/edit
  def edit
    @message = Message.find(params[:id])
    authorize! :update, @message
  end

  # POST /messages
  # rubocop: disable Metrics/AbcSize
  def create
    @message = @user.messages.new(message_params)

    if @message.save
      flash[:success] = "Successfully added new message."
      redirect_to messages_path
    else
      flash[:error] = @message.errors.messages.values.flatten.uniq
      render :new
    end
  end
  # rubocop: enable Metrics/AbcSize

  # PATCH /messages/:id
  # rubocop: disable Metrics/AbcSize
  def update
    @message = Message.find(params[:id])
    authorize! :update, @message

    if @message.update(message_params)
      flash[:success] = "Successfully updated message."
      redirect_to messages_path
    else
      flash[:error] = @message.errors.messages.values.flatten.uniq
      render :edit
    end
  end
  # rubocop: enable Metrics/AbcSize

  # DELETE /messages/:id
  def destroy
    @message = Message.find(params[:id])
    authorize! :destroy, @message
    @message.destroy

    redirect_to messages_path
  end

  private

  def message_params
    params.require(:message).permit(:subject, :body)
  end

  def set_user
    @user = current_user
  end
end
