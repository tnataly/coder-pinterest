# This will guess the User class
FactoryGirl.define do
	factory :user do
		sequence(:email) { |n| "coder#{n}@skillcrush.com" }
		first_name "skillcrush"
		last_name "Coder"
		password "secret"
	end
	
end