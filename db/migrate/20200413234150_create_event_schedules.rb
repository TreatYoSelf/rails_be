class CreateEventSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :event_schedules do |t|
      t.string :event_name
      t.timestamp :event_start_time
      t.timestamp :event_end_time

      t.timestamps
    end
  end
end
