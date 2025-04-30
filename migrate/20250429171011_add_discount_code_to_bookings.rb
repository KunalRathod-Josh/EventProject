class AddDiscountCodeToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :discount_code, :string
  end
end
