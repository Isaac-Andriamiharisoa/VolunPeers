module SvgHelper
  def svg_icon(filename, options = {})
    file_path = Rails.root.join('app', 'assets', 'images', "#{filename}.svg")
    return unless File.exist?(file_path)

    svg_content = File.read(file_path)
    options[:class] += " svg"
    content_tag(:div, svg_content.html_safe, options)
  end
end
