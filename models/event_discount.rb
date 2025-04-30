class EventDiscount < ApplicationRecord
  belongs_to :event

  DISCOUNT_TYPES = %w[EarlyBird AmountDiscount]

  validates :name, presence: true
  validates :discount_type, presence: true, inclusion: { in: DISCOUNT_TYPES }
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :valid_until, presence: true, if: -> { discount_type == "EarlyBird" }
  validates :min_total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: -> { discount_type == "AmountDiscount" }
end
