module ApplicationHelper
  def is_active_page?(link)
    current_page?(link) ? "active" : ""
  end
end
