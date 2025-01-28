module NavbarHelper
  def navbar(chatroom_id)
    @chatroom_id = chatroom_id
    content_tag(:div, class: 'navbar') do
      concat(svg_icon("logo", class: 'svg--40'))
      concat(generate_links.html_safe)
    end
  end

  private

  def generate_links
    content_tag(:ul, class: 'navbar__link-container') do
      navbar_links.each do |key, value|
        concat(tag.li(class: 'nav-item') do
          link_to(key, value, class: 'nav-link px-5 text-center text-light text-bold text-center fs-5')
        end)
      end
    end
  end

  def navbar_links
    user_signed_in? ? logged_in_links : logged_out_links
  end

  def logged_in_links
    { "Home" => root_path,
      "Causes" => events_path,
      "Agenda" => calendar_path,
      "Chatrooms" => chatroom_path(@chatroom_id),
      "About Us" => about_path }
  end

  def logged_out_links
    { "Home" => root_path,
      "Causes" => events_path,
      "About Us" => about_path,
      "Login" => new_user_session_path }
  end
end
