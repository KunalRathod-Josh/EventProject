class CreateBookingGuests < ActiveRecord::Migration[8.0]
  def change
    create_table :booking_guests do |t|
      t.references :booking, foreign_key: true
      t.string :name, null: false
      t.integer :age
      t.string :id_proof, null: false
      t.timestamps
    end
  end
end
