class Downvote < ActiveRecord::Base

	#
	# Associations
	#
	belongs_to :idea
	has_one :user
	
end
