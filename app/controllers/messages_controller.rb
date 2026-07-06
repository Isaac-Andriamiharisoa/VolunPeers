class MessagesController < ApplicationController
  def create
    @chatroom = current_user.participated_chatrooms.find(params[:chatroom_id])
    @message = @chatroom.messages.new(message_params)
    @message.user = current_user

    # The message broadcasts itself to the chatroom's Turbo Stream on commit
    # (see Message#after_create_commit), so we only acknowledge the request here.
    if @message.save
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
