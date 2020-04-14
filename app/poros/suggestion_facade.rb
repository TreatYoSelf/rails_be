class SuggestionFacade
	def initialize(current_user)
		@current_user = current_user
	end

	def create_event_schedule
		@current_user.event_schedules.create(event_name: event_params[0],
																				 event_start_time: event_params[1],
																				 event_end_time: event_params[2])
	end

	private

	def event_params
		new_event = schedule_activities
		start = new_event.start.date_time
		end_time = new_event.end.date_time
		summary = new_event.summary
		[summary, start, end_time]
	end

	def schedule_activities
		scheduler = SchedulerService.new(@current_user)
		scheduler.schedule_suggestions
	end
end
