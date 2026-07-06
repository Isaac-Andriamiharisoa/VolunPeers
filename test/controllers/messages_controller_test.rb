require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

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

  test "the broadcast message partial renders without a current_user" do
    # Turbo broadcasts render the partial outside any request, so it must not
    # depend on current_user; bubble alignment happens client-side instead.
    message = @chatroom.messages.create!(content: "Broadcast safe", user: @user)
    html = ApplicationController.render(partial: "messages/message", locals: { message: message })

    assert_includes html, "Broadcast safe"
    assert_includes html, %(data-user-id="#{@user.id}")
    refute_includes html, "message--left"
    refute_includes html, "message--right"
  end

  test "create requires an authenticated user" do
    sign_out @user

    assert_no_difference "Message.count" do
      post chatroom_messages_url(@chatroom), params: { message: { content: "Nope" } }
    end
    assert_redirected_to new_user_session_path
  end
end
