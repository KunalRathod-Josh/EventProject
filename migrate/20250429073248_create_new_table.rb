class CreateNewTable < ActiveRecord::Migration[8.0]
  def change
    create_table :new_tables do |t|
      add_column :booking_guests, :name, :string
      add_column :booking_guests, :age, :integer

      t.timestamps
    end
  end
end
