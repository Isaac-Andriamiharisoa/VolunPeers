class ChatroomsController < ApplicationController
  before_action :set_chatrooms, only: %i[index show]

  def index
    @active_chatroom = @chatrooms.first
  end

  # Rendered into the "conversation" Turbo Frame when a sidebar item is clicked,
  # and as a full page on direct navigation to /chatrooms/:id.
  def show
    @active_chatroom = @chatrooms.find(params[:id])
    render :index
  end

  def delete_conversation
    @chatroom = current_user.participated_chatrooms.find(params[:id])
    @chatroom.messages.destroy_all
    redirect_to chatrooms_path, notice: 'Conversation deleted successfully.'
    headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    headers['Pragma'] = 'no-cache'
    headers['Expires'] = '0'
  end

  private

  def set_chatrooms
    @chatrooms = current_user.participated_chatrooms.includes(:messages)
    @hide_footer = true
    @body_class = "chatroom-shell"
  end
end
