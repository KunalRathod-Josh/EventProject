class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.date :start_date
      t.date :end_date
      t.string :title
      t.string :description
      t.string :banner_url
      t.references :location, foreign_key: true
      t.references :category, foreign_key: true
      t.references :organiser, foreign_key: { to_table: :users }
      t.bigint :base_ticket_price
      t.boolean :is_early_bird_active
      t.boolean :is_amount_discount_active
      t.timestamps
    end
  end
end
