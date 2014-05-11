class User < ActiveRecord::Base
  	
  	#
  	# Constantes
  	#
	ROLES = %w(admin user)
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	#
	# Associations
	# 	
 	belongs_to :account, foreign_key: 'account_id'

 	# Thumbsup Gem 
 	acts_as_voter
 	
 	# Paranoid Gem
 	acts_as_paranoid

	#
	# Devise configuration   (Include default devise modules. Others available are:
 	# 					:confirmable, :lockable, :timeoutable, :omniauthable and :validatable)
	#
 	devise :database_authenticatable, :recoverable, :rememberable 


 	#
 	# Before callbacks
 	#
 	before_validation :downcase_email	

 	#
 	# Validations (TODO : Voir comment envoyer des messages paramètrables)
 	#
 	validates :name, 	presence:  { :message => "Name required" }
  validates :role, 	presence: true,
  					 	inclusion: { in: ROLES, messages: 'not a valid role' } 
  validates :email, :uniqueness_without_deleted => {:scope => :account_id, :case_sensitive => false}
	validates_format_of :email,	 	{ :with  => Devise.email_regexp,   :message => "email invalid" }
	validates_presence_of   :password, :on=>:create
	validates_confirmation_of   :password, :on=>:create
	validates_length_of :password, :within => Devise.password_length, :allow_blank => true

 # protected
 #   def self.find_for_database_authentication(warden_conditions)
 #     conditions = warden_conditions.dup
 #     login = conditions.delete(:login)
 #     account_id = conditions.delete(:account_id)
 #     where(conditions).where(["lower(email) = :value", { :value => name.downcase }]).where("account_id = ?", account_id).first
 #   end

 	def cost(month, year)
 		ppm = 10.0
 		date = Date.new(year, month, 01)	
 		if self.deleted_at == nil	 		 		
	 		if (self.created_at.year>year) || (self.created_at.year==year && self.created_at.month>month) #si l'utilisateur a été créé aprés le month/year son cout est nul pr ce mois
	 			return 0
	 		elsif (self.created_at.year<year) || (self.created_at.year==year && self.created_at.month<month)  #si l'utilisateur a été créé avant month son cout est ppm
	 			return ppm #pri
	 		elsif (self.created_at.month == month && self.created_at.year == year) #si l'utilisateur a été créé au cours de ce mois son cout est ppm au prorata
	 			return ppm*((date.end_of_month.day.to_f - self.created_at.day.to_f)/ date.end_of_month.day)
	 		end
	 	else 
	 		if self.deleted_at.year<year || (self.deleted_at.year==year && self.deleted_at.month<month)
	 			return 0;
	 		elsif self.deleted_at.year>year || (self.deleted_at.year==year && self.deleted_at.month>month)
	 			if (self.created_at.year>year) || (self.created_at.year==year && self.created_at.month>month) #si l'utilisateur a été créé aprés le month/year son cout est nul pr ce mois
		 			return 0
		 		elsif (self.created_at.year<year) || (self.created_at.year==year && self.created_at.month<month)  #si l'utilisateur a été créé avant month son cout est ppm
		 			return ppm #pri
		 		elsif (self.created_at.month == month && self.created_at.year == year) #si l'utilisateur a été créé au cours de ce mois son cout est ppm au prorata
		 			return ppm*((date.end_of_month.day.to_f - self.created_at.day.to_f)/ date.end_of_month.day)
	 			end
	 		elsif  (self.deleted_at.month==month && self.deleted_at.year==year)
	 			if (self.created_at.year<year) || (self.created_at.year==year && self.created_at.month<month)  #si l'utilisateur a été créé avant month son cout est ppm
		 			return ppm*((self.deleted_at.day.to_f)/date.end_of_month.day) #pri
		 		elsif (self.created_at.month == month && self.created_at.year == year) #si l'utilisateur a été créé au cours de ce mois son cout est ppm au prorata
		 			return ppm*((self.deleted_at.day.to_f - self.created_at.day.to_f)/ date.end_of_month.day)
		 		end
	 		end
	 	end
 	end
  
  private
	def downcase_email
		self.email = email.downcase if email.present?
	end
end
