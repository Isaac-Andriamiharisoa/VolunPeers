class ChatroomsController < ApplicationController
  def index
    @chatrooms = current_user.chatrooms
    @message = Message.new
  end
end
