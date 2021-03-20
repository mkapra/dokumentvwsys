class Role < ApplicationRecord
  has_many :users

  def translated
    "#{I18n.t("role.#{name}")}: #{I18n.t("role.description.#{name}")}"
  end

  def admin?
    name == "admin"
  end

  def uploader?
    name == "uploader"
  end

  def user?
    name == "user"
  end
end
