class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.float :amount
      t.string :status
      t.references :booking, foreign_key: true
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.string :order_status
      t.string :phone_number
      t.timestamps
    end
  end
end
