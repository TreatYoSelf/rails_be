class Api::V1::SuggestionsController < ApplicationController
	def create
		create_user_activities
	end

	def index
		render json: { getUserEvents: suggestions }
	end

	private

	def suggestions
		SuggestionFacade.new(current_user).create_event_schedule
	end

	def create_user_activities
		category_ids = params[:category].map do |name|
			category = Category.find_by(name: name)
			category.id
		end

		activities = CategoryActivity.where(category_id: [category_ids])
		current_user.category_activities << activities
	end
end
