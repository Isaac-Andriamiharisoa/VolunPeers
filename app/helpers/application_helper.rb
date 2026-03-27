module ApplicationHelper
  def inline_svg(filename, options = {})
    file_path = Rails.root.join("app", "assets", "images", "#{filename}.svg")

    if File.exist?(file_path)
      file = File.read(file_path)
      doc = Nokogiri::HTML::DocumentFragment.parse(file)
      svg = doc.at_css("svg")

      if svg
        options.each { |key, value| svg[key] = value }
        svg.to_html.html_safe
      else
        ""
      end
    else
      ""
    end
  end
end
