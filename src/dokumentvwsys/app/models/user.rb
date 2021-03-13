class User < ApplicationRecord
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable

  has_many :documents

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == 'admin'
  end

  def birthdate_string
    birth.strftime('%d.%m.%Y')
  end

  def to_s
    "#{full_name} (#{birthdate_string})"
  end
end
