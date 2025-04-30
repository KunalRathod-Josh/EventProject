class Event < ApplicationRecord
  belongs_to :location
  belongs_to :category
  belongs_to :organizer, class_name: "User", foreign_key: "organizer_id"

  has_many :event_discounts, dependent: :destroy
  has_many :bookings, dependent: :destroy

  has_one_attached :banner

  accepts_nested_attributes_for :event_discounts, allow_destroy: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validate :end_after_start

  validates :base_ticket_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :location_id, presence: true
  validates :category_id, presence: true
  validates :organizer_id, presence: true
end
