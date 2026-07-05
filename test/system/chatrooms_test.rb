require "application_system_test_case"

# These cover the load-time chat behaviours that do not depend on live
# ActionCable delivery (the test cable adapter does not push to browser
# websockets). Live append / auto-scroll on broadcast is covered by the
# controller broadcast assertion in MessagesControllerTest.
class ChatroomsTest < ApplicationSystemTestCase
  setup do
    @password = "password123"
    @user = create_user(password: @password)
    @chatroom = create_chatroom_with_participant(@user)
    15.times { |n| @chatroom.messages.create!(user: @user, content: "Seed message #{n}") }
  end

  test "opens with the first conversation active and scrolled to the latest message" do
    sign_in_through_ui

    assert_selector "li[data-chatroom-id='#{@chatroom.id}'].active"

    assert scrolled_to_bottom?(@chatroom),
           "expected the messages container to be scrolled to the bottom on load"
  end

  private

  def sign_in_through_ui
    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @password
    # Submit without Turbo so the session cookie is set via a full navigation
    # (Turbo's fetch submit is flaky under headless Chrome).
    execute_script("document.querySelector('form').setAttribute('data-turbo', 'false')")
    click_button "Log in"
    assert_text "Signed in successfully"
    visit chatrooms_path
  end

  def scrolled_to_bottom?(chatroom)
    page.evaluate_script(<<~JS)
      (() => {
        const el = document.querySelector(
          ".event-#{chatroom.id} [data-chatroom-subscription-target='latestMessages']"
        );
        if (!el) return false;
        const overflowing = el.scrollHeight > el.clientHeight;
        const atBottom = Math.abs(el.scrollHeight - el.clientHeight - el.scrollTop) < 5;
        return overflowing && atBottom;
      })()
    JS
  end
end
