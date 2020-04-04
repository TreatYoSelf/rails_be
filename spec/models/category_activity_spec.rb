require 'rails_helper'

RSpec.describe CategoryActivity, type: :model do
	describe "Relationships" do 
		it {should belong_to :category}
		it {should belong_to :activity}
	end
end