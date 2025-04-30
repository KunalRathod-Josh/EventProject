class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :payment_method
      t.decimal :amount, precision: 10, scale: 2
      t.string :status
      t.string :transaction_id
      t.datetime :payment_date
      t.timestamps
    end
  end
end
