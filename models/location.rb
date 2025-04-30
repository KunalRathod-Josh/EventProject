class Location < ApplicationRecord
  has_many :events

  validates :name, presence: true, uniqueness: { scope: [ :address, :city ], message: "with the same address and city already exists" }
  validates :address, presence: true
  validates :city, presence: true
  validates :pin_code, presence: true, format: { with: /\A\d{5,6}\z/, message: "should be 5 or 6 digits" }
end
