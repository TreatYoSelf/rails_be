require 'rails_helper'

describe 'it can find google calendar endpoints', :vcr do
  it 'GET /api/v1/google_calendar returns a collection calendar events' do
    get "/api/v1/google_calender"
      expect(response).to have_http_status(:success)
  end
end
