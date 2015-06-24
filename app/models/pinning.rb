class Pinning < ActiveRecord::Base
	belongs_to :pin
	belongs_to :user
end
