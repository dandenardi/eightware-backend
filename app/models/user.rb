class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  before_create :generate_jti

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def jwt_payload
    {
      user_id: id,
      email: email
    }
  end

  private

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end
end
