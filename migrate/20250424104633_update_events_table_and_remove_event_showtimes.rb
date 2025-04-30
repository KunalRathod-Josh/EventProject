class UpdateEventsTableAndRemoveEventShowtimes < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :start_date, :start_datetime
    rename_column :events, :end_date, :end_datetime
    add_column :events, :capacity, :integer

    remove_foreign_key :bookings, :event_showtimes

    drop_table :event_showtimes
  end
end
