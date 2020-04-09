class Api::V1::SuggestionsController < ApplicationController 
	def create
		render json: SuggestionSerializer.new(suggestions)
	end

	private
	def suggestions
		SuggestionFacade.new(params)
	end
end 