class RenameTypeTpDiscountType < ActiveRecord::Migration[8.0]
  def change
    rename_column :event_discounts, :type, :discount_type
  end
end
