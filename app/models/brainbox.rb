class Brainbox < ActiveRecord::Base

	#
	# => Associations
	#
	belongs_to :account
	has_many :ideas

	 	
 	# Paranoid Gem
 	acts_as_paranoid
 	#validates_as_paranoid

	#
	# => Validations
	#
	validates :name, presence: true
 # validates_uniqueness_of_without_deleted :name, :scope=> :account_id, :case_sensitive => false
 	validates :name, :uniqueness_without_deleted => {:scope => :account_id, :case_sensitive => false}
#	validates_uniqueness_of :name, 	:scope => :account_id,
 #										:case_sensitive => false, :uniqueness_without_deleted => true
	validates :descr, presence: true

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

end
