class User < ActiveRecord::Base
	has_many :pinnings, dependent: :destroy
	has_many :pins, through: :pinnings
	has_many :boards
	validates_presence_of :first_name, :last_name, :email, :password
	validates_uniqueness_of :email
	has_secure_password

	def self.authenticate(email, password)
		@user = User.find_by_email(email)

		unless @user.nil?
			if @user.authenticate(password)
				return @user
			end
		end
		return nil
		#User.where("email = ? AND password = ?", email, password ).first
	end
end
