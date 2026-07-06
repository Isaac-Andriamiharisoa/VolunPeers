require "test_helper"

class ChatroomsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create_user
    @chatroom = create_chatroom_with_participant(@user)
    @chatroom.messages.create!(content: "Welcome aboard", user: @user)
    sign_in @user
  end

  test "index renders the conversation frame, composer and sidebar link" do
    get chatrooms_url

    assert_response :success
    assert_select "turbo-frame#conversation"
    assert_select "form.messages__form"
    assert_select "a.chatroom__list-item[href=?]", chatroom_path(@chatroom)
    assert_includes response.body, "Welcome aboard"
  end

  test "show renders the conversation frame for the requested chatroom" do
    get chatroom_url(@chatroom)

    assert_response :success
    assert_select "turbo-frame#conversation"
    assert_includes response.body, "Welcome aboard"
  end

  test "show 404s for a chatroom the user does not participate in" do
    other = create_chatroom_with_participant(create_user)

    get chatroom_url(other)
    assert_response :not_found
  end

  test "delete_conversation clears the messages and redirects" do
    assert @chatroom.messages.any?

    delete delete_conversation_chatroom_url(@chatroom)

    assert_redirected_to chatrooms_path
    assert_empty @chatroom.reload.messages
  end
end
