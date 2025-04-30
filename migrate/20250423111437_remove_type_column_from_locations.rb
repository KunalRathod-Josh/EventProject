class RemoveTypeColumnFromLocations < ActiveRecord::Migration[8.0]
  def change
    remove_column :locations, :type
  end
end
