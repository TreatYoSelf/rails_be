require 'rails_helper'

RSpec.describe EventSchedule, type: :model do
	describe "Validations" do
		it {should validate_presence_of :event_name}
		it {should validate_presence_of :event_start_time}
		it {should validate_presence_of :event_end_time}
	end

	describe "Relationships" do 
		it {should belong_to :user}
	end
end
