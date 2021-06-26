class User < ApplicationRecord
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable

  belongs_to :role
  has_many :documents, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role.admin?
  end

  def birthdate_string
    birth.strftime('%d.%m.%Y')
  end

  def to_s
    "#{full_name} (#{birthdate_string})"
  end
end
