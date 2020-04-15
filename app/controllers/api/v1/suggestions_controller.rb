class Api::V1::SuggestionsController < ApplicationController
	def create
	p params
		create_user_activities
		render json: { response: "Successfully created user activities" }
	end

	def index
		render json: { events: SuggestionFacade.new(current_user).create_event_schedule}
	end

	private

	def create_user_activities
		category_ids = params["_json"].map do |name|
			category = Category.find_by(name: name)
			category.id
		end
		activities = CategoryActivity.where(category_id: [category_ids])
		current_user.category_activities << activities
	end
end
