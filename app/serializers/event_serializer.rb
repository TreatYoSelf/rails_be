class EventSerializer
    include FastJsonapi::ObjectSerializer
    attributes :id, :event_name, :event_start_time, :event_end_time, :weekday
end
