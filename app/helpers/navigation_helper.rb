module NavigationHelper
  def signed_in_links
    {
      "Home" => root_path,
      "Causes" => events_path,
      "Agenda" => calendar_path,
      "Chatrooms" => chatrooms_path,
      "About us" => about_path,
    }
  end

  def signed_out_links
    {
      "Home" => root_path,
      "Causes" => events_path,
      "About us" => about_path,
    }
  end
end