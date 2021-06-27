module ApplicationHelper
  def is_active_page?(link)
    current_page?(link) ? 'active' : ''
  end

  def icon(icon, options = {})
    file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    svg['class'] += " #{options[:class]}" if options[:class].present?
    doc.to_html.html_safe
  end

  def navbar_item(label, path)
    "<li class=\"nav-item #{is_active_page? path}\">
      #{link_to t("navbar.#{label}"), path, class: 'nav-link'}
    </li>".html_safe
  end

  def navbar_dropdown_item(label, path)
    "<li>#{link_to t("navbar.#{label}"), path, class: 'dropdown-item'}</li>".html_safe
  end

  def inline_help(help_text, object_name, method)
    content_tag :small, help_text, class: 'form-text', id: "#{object_name}_#{method}_inline"
  end

  def get_logo
    return 'data:image/png;base64,' + Base64.encode64(Preference.find_by_key('image').file)
  end
end
