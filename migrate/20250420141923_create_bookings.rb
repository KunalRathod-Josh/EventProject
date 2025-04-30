class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.integer :quantity, null: false
      t.float :total_price, null: false
      t.string :status, default: 'pending'
      t.string :discount_applied
      t.timestamps
    end
  end
end
