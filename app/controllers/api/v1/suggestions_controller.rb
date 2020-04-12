class Api::V1::SuggestionsController < ApplicationController
	def create
		render json: { scheduled_treat: suggestions }
	end

	private
	def suggestions
		current_user = User.first
		SuggestionFacade.new(current_user).schedule_activities
	end
end
