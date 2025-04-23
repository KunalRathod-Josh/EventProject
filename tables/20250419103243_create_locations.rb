class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :address
      t.string :name
      t.string :type
      t.string :city
      t.string :pin_code
      t.timestamps
    end
  end
end
