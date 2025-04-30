class ChangeEventDatesToDatetime < ActiveRecord::Migration[8.0]
  def change
    change_column :events, :start_datetime, :datetime
    change_column :events, :end_datetime, :datetime
  end
end
