class Account < ActiveRecord::Base

	#
	# Constantes
	#

	RESTRICTED_SUBDOMAINS = %w(www)
	SUBSCRIPTION_TYPES = %w(free basic premium payasyougo)

	#
	# Associations
	#

	has_one :owner, class_name: 'User' 
	has_many :users
	has_many :brainboxes

	#
	# Validations
	#

	validates :owner, presence: true

	validates :subdomain, 	presence: true,
							uniqueness: { case_sensitive: false },
							format: { with: /\A[\w\-]+\Z/i, message: 'contains invalid characters' },
							exclusion: { in: RESTRICTED_SUBDOMAINS, message: 'restricted' }
	
	validates :subscription_type, 	presence: true,
									 inclusion: { in: SUBSCRIPTION_TYPES, messages: 'not a valid subscription_type' }


	#
	# Before callbacks
	#		

	before_validation :downcase_subdomain		

	#
	# Accepts_nested_attributes 
	#			 
	
	accepts_nested_attributes_for :owner
	accepts_nested_attributes_for :users

	def bbs_max
		return 1 if self.subscription_type=="free"
		return 5 if self.subscription_type=="basic"
		return 10 if self.subscription_type=="premium"
		return -1 if self.subscription_type=='payasyougo'
	end

	def ideas_max
		return 5 if self.subscription_type=="free"
		return 10 if self.subscription_type=="basic"
		return 15 if self.subscription_type=="premium"
		return -1 if self.subscription_type=='payasyougo'
	end

	def users_max
		return 5 if self.subscription_type=='free'
		return 10 if self.subscription_type=='basic'
		return 15 if self.subscription_type=='premium'
		return -1 if self.subscription_type=='payasyougo'
	end

	def cost(month, year)
		cout = 0
		self.brainboxes.with_deleted.each do |bb|
			cout+= bb.cost(month, year).round(2)
		end
		self.users.with_deleted.each do |user|
			cout+= user.cost(month, year).round(2)
		end
		return cout
	end 

private
	def downcase_subdomain
		self.subdomain = subdomain.downcase if subdomain.present?
	end

end
