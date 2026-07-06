require "application_system_test_case"

# Covers the load-time chat behaviours that don't depend on live ActionCable
# delivery (the test cable adapter doesn't push to browser websockets). The
# broadcast partial rendering is covered in MessagesControllerTest.
class ChatroomsTest < ApplicationSystemTestCase
  setup do
    @password = "password123"
    @user = create_user(password: @password)
    @chatroom = create_chatroom_with_participant(@user)
    50.times { |n| @chatroom.messages.create!(user: @user, content: "Seed message #{n}") }
  end

  test "opens with the first conversation active and scrolled to the latest message" do
    sign_in_through_ui

    assert_selector "a.chatroom__list-item--active"
    assert_selector "turbo-frame#conversation .message", minimum: 1

    assert scrolled_to_bottom?,
           "expected the messages list to be scrolled to the bottom on load"
  end

  test "a message appended to the open conversation gets the appear animation" do
    sign_in_through_ui

    # Simulate a Turbo Stream broadcast appending a message to the list.
    execute_script(<<~JS)
      const list = document.querySelector("#messages_#{@chatroom.id}");
      const el = document.createElement("div");
      el.className = "message";
      el.dataset.userId = "#{@user.id}";
      el.dataset.createdAt = new Date().toISOString();
      el.innerHTML = '<div class="message__group">' +
        '<div class="message__bubble"><p class="message__body">Live ping</p></div></div>';
      list.appendChild(el);
    JS

    # The conversation controller decorates it: side class + the appear animation.
    assert_selector "#messages_#{@chatroom.id} .message.message--new.message--right", text: "Live ping"
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

  def scrolled_to_bottom?
    page.evaluate_script(<<~JS)
      (() => {
        const el = document.querySelector("#messages_#{@chatroom.id}");
        if (!el) return false;
        const overflowing = el.scrollHeight > el.clientHeight;
        const atBottom = Math.abs(el.scrollHeight - el.clientHeight - el.scrollTop) < 5;
        return overflowing && atBottom;
      })()
    JS
  end
end
