class Payment < ApplicationRecord
  belongs_to :booking
  belongs_to :user

  validates :payment_method, :amount, :transaction_id, :status, :payment_date, presence: true
end
