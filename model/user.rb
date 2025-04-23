class User < ApplicationRecord
  belongs_to :role
  has_many :bookings

  has_secure_password

  validates :email, presence: true, uniqueness: true
end
