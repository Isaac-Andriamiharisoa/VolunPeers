require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionCable::TestHelper

  setup do
    @user = create_user
    @chatroom = create_chatroom_with_participant(@user)
    sign_in @user
  end

  test "create persists the message for the current user and returns no content" do
    assert_difference "Message.count", 1 do
      post chatroom_messages_url(@chatroom), params: { message: { content: "Hello world" } }
    end

    assert_response :no_content
    message = Message.last
    assert_equal "Hello world", message.content
    assert_equal @user, message.user
    assert_equal @chatroom, message.chatroom
  end

  test "create broadcasts the rendered message to the chatroom stream" do
    assert_broadcasts(ChatroomChannel.broadcasting_for(@chatroom), 1) do
      post chatroom_messages_url(@chatroom), params: { message: { content: "Ping" } }
    end
  end

  test "create requires an authenticated user" do
    sign_out @user

    assert_no_difference "Message.count" do
      post chatroom_messages_url(@chatroom), params: { message: { content: "Nope" } }
    end
    assert_redirected_to new_user_session_path
  end
end
