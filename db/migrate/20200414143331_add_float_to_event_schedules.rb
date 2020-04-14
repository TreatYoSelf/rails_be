class AddFloatToEventSchedules < ActiveRecord::Migration[6.0]
  def change
    remove_column :event_schedules, :event_start_time, :timestamp
    remove_column :event_schedules, :event_end_time, :timestamp
    add_column :event_schedules, :event_start_time, :float
    add_column :event_schedules, :event_end_time, :float
    add_column :event_schedules, :weekday, :string
  end
end
