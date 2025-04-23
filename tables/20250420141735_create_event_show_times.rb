class CreateEventShowTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :event_show_times do |t|
      t.references :event, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :capacity
      t.timestamps
    end
  end
end
