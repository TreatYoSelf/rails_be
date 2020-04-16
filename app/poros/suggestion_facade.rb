class SuggestionFacade
	def initialize(current_user)
		@current_user = current_user
	end

	def schedule_activities
		scheduler = SchedulerService.new(@current_user)
		scheduler.create_event
	end
	# def create_event_schedule
	# 		EventSchedule.create!(event_name: event_params[0],
	# 											event_start_time: event_params[1],
	# 											event_end_time: event_params[2],
	# 											user_id: @current_user.id)
	# end

	private

	# def event_params
	# 	event = schedule_activities
	# 	summary = event.summary
	# 	start = event.start.date_time.to_f
	# 	end_time = event.end.date_time.to_f
	# 	[summary, start, end_time]
	# end


end
