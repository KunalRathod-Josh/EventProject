class DropPaymentsTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :payments
  end

  def down
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :payment_method
      t.string :transaction_id
      t.decimal :amount, precision: 10, scale: 2
      t.string :status, default: 'pending'
      t.datetime :payment_date

      t.timestamps
    end
  end
end
