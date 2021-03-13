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
end
