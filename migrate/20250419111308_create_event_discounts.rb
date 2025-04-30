class CreateEventDiscounts < ActiveRecord::Migration[8.0]
  def change
    create_table :event_discounts do |t|
      t.references :event, foreign_key: true
      t.string :name
      t.string :discount_type
      t.date :valid_until
      t.float :min_total_amount
      t.float :discount_value, null: false
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
