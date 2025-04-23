class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :event_show_time
  has_many :booking_guests
  has_many :payment
end
