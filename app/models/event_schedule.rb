class EventSchedule < ApplicationRecord
  validates_presence_of :event_name
  validates_presence_of :event_start_time
  validates_presence_of :event_end_time

  belongs_to :user
end
