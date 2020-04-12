class SuggestionFacade 
	def initialize(params)
		user = params["user_id"]
		est_time = params["est_time"]
		category = params["category"]
	end

	def choose_activities
		Suggestion.new(params)
	end
end