class SuggestionFacade
	def initialize(current_user)
		@current_user = current_user
	end

	def create_event_schedule
	    events =  schedule_activities.map do |event|
			event_details = event_params(event)
			EventSchedule.create(event_name: event_details[0],
												event_start_time: event_details[1],
												event_end_time: event_details[2],
												weekday: event_details[3],
												user_id: @current_user.id)
		end
		events
	end

	private

	def event_params(event)
		start = event.start.date_time.to_f
		end_time = event.end.date_time.to_f
		weekday = event.start.date_time.strftime("%A")
		summary = event.summary
		[summary, start, end_time, weekday]
	end

	def schedule_activities
		scheduler = SchedulerService.new(@current_user)
		scheduler.schedule_suggestions
	end
end
