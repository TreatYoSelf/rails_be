class Api::V1::SuggestionsController < ApplicationController
	def create
		#render json: SuggestionSerializer.new(suggestions)
		suggestions
	end

	private
	def suggestions
		current_user = User.first
		SuggestionFacade.new(current_user).schedule_activities
	end
end
