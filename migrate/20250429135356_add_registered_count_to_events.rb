class AddRegisteredCountToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :registered_count, :integer, default: 0
  end
end
