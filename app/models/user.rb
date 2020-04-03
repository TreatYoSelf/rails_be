class User < ApplicationRecord
validates_presence_of :first_name, :last_name, :google_token, :self_care_time
validates :email, uniqueness: true

has_many :user_activities, dependent: :destroy
has_many :categorie_activities, through: :user_activities
end
