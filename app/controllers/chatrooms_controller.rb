class ChatroomsController < ApplicationController
  def index
    @chatrooms = current_user.participated_chatrooms
    @chatroom = params[:id].present? ? Chatroom.find(params[:id]) : @chatrooms.first
    @message = Message.new
    @hide_footer = true
  end

  def show
    @chatroom = Chatroom.includes(:messages).find(params[:id])
    @message = Message.new
    @hide_footer = true

    render turbo_stream: :index, locals: {chatroom: @chatroom}
  end

  def delete_conversation
    @chatroom = Chatroom.find(params[:id])
    @chatroom.messages.destroy_all
    redirect_to chatrooms_path, notice: 'Conversation deleted successfully.'
    headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    headers['Pragma'] = 'no-cache'
    headers['Expires'] = '0'
  end
end
