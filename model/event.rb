class Event < ApplicationRecord
  belongs_to :location
  belongs_to :category
  belongs_to :organizer, class_name: "User"
  has_many :event_discounts
  has_many :event_showtimes
  has_many :bookings
end
