class Api::V1::Users::EventsController < ApplicationController
	def index
		render json: {
			events: current_user.event_schedules
		}
	end
end