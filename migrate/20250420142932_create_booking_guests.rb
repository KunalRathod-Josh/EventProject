class CreateBookingGuests < ActiveRecord::Migration[8.0]
  def change
    create_table :booking_guests do |t|
      t.references :booking, foreign_key: true
      t.string :name, null: false
      t.integer :age
      t.timestamps
    end
  end
end
