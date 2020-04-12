class Api::V1::SuggestionsController < ApplicationController
	def create
		create_user_activities
		render json: { scheduled_treat: suggestions }
	end

	private
	def suggestions
		current_user = User.first # needs to be changed once we have a current user
		SuggestionFacade.new(current_user).schedule_activities
	end

	def create_user_activities
		current_user = User.first # needs to be changed once we have a current user
		category_ids = params[:category].map do |name|
			category = Category.find_by(name: name)
			category.id
		end

		activities = CategoryActivity.where(category_id: [category_ids])
		current_user.category_activities << activities
	end
end
