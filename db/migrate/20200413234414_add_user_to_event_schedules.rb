class AddUserToEventSchedules < ActiveRecord::Migration[6.0]
  def change
    add_reference :event_schedules, :user, null: false, foreign_key: true
  end
end
