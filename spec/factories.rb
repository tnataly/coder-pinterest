

# This will guess the User class
FactoryGirl.define do
	# Adding ping 
	factory :pin do
		title "Rails Cheatsheet"
		url "http://rails-cheat.com"
		text "A great tool for beginning developers"
		slug
		category Category.find_by_name("rails")
	end
	sequence :slug do |n|
		"slug#{n}"
	end
	
	factory :user do
		sequence(:email) { |n| "coder#{n}@skillcrush.com" }
		first_name "skillcrush"
		last_name "Coder"
		password "secret"

		after(:create) do |user|
			create_list(:pin, 3)
		end
	end
	
end