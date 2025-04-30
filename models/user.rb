class User < ApplicationRecord
  belongs_to :role
  has_many :bookings
  has_many :events, foreign_key: :organizer_id

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :name, presence: true

  with_options if: :organizer? do |organizer|
    organizer.validates :organisation_name, presence: true
    organizer.validates :bio, presence: true
  end

  private

  def organizer?
    role&.name == "Organizer"
  end
end
