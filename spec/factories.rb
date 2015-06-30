

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
	
	factory :board do
		name "My Pins!"
	end

	factory :user do
		sequence(:email) { |n| "coder#{n}@skillcrush.com" }
		first_name "Janny"
		last_name "Coder"
		password "secret"

		after(:create) do |user|
			user.boards << FactoryGirl.create(:board)
			3.times do
				user.pinnings.create(pin: FactoryGirl.create(:pin), board: user.boards.first)
			end
		end
	end

	factory :pinning do
		pin
		user
	end	
	
end