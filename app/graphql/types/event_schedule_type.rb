module Types
  class EventScheduleType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: false
    field :event_name, String, null: false
    field :event_start_time, Float, null: false
    field :event_end_time, Float, null: false
    field :weekday, String, null: false
    field :user_events, Types::UserType, null: true

    def user_events
      object.event_schedules
    end
  end
end
