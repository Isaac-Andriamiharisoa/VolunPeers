require "test_helper"

class ChatroomChannelTest < ActionCable::Channel::TestCase
  setup do
    @user = create_user
    @chatroom = create_chatroom_with_participant(@user)
    stub_connection(current_user: @user)
  end

  test "subscribes and streams for the requested chatroom" do
    subscribe(id: @chatroom.id)

    assert subscription.confirmed?
    assert_has_stream_for @chatroom
  end

  test "raises when the chatroom does not exist" do
    assert_raises(ActiveRecord::RecordNotFound) do
      subscribe(id: -1)
    end
  end
end
