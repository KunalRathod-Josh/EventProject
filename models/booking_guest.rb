class BookingGuest < ApplicationRecord
  belongs_to :booking

  has_one_attached :id_proof

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :booking_id, presence: true
end
