class AddTotalAmountToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :total_amount, :decimal
  end
end
