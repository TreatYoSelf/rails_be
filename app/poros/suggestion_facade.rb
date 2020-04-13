class SuggestionFacade
	def initialize(current_user)
		@current_user = current_user
	end

	def schedule_activities
		scheduler = SchedulerService.new(@current_user)
		scheduler.schedule_suggestions
	end
end
