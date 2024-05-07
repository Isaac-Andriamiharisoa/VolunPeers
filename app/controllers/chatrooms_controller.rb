class ChatroomsController < ApplicationController
  def show
    @chatrooms = current_user.participated_chatrooms
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
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
