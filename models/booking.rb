class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :booking_guests
  has_one :payment

  accepts_nested_attributes_for :booking_guests, allow_destroy: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :event_id, presence: true
  validates :user_id, presence: true
  validates :status, inclusion: { in: %w[pending confirmed cancelled completed], message: "%{value} is not a valid status" }, allow_nil: true

  def total_amount
    base_price = event.base_ticket_price
    discount = event.event_discounts.find_by(name: discount_code, is_active: true)
    discount_value = discount ? discount.discount_value : 0
    (base_price * quantity * (1 - discount_value / 100.0)).round(2)
  end
end
