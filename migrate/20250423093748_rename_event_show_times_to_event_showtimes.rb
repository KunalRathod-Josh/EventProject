class RenameEventShowTimesToEventShowtimes < ActiveRecord::Migration[7.0]
  def change
    rename_table :event_show_times, :event_showtimes
  end
end
