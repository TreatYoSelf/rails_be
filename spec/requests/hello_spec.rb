require 'rails_helper'

describe 'hello' do
	it 'can get hello' do
		get '/hello'
		
		# require 'pry'; binding.pry
	end
end