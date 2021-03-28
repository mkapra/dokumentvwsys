class Preference < ApplicationRecord
  def to_s
    return '' if is_file
    return value.html_safe if is_textarea

    value
  end
end
