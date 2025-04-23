class EventShowTime < ApplicationRecord
  belongs_to :event
  has_many :bookings
end
