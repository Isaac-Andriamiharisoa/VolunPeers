class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  # Append the new message to every subscriber's conversation over Turbo Streams.
  # The rendered HTML is identical for all viewers; the conversation Stimulus
  # controller aligns each bubble (left/right) from data-user-id on the client.
  after_create_commit lambda {
    broadcast_append_to(
      chatroom,
      target: "messages_#{chatroom_id}",
      partial: "messages/message",
      locals: { message: self }
    )
  }
end
