class Idea < ActiveRecord::Base

	#
	# => Associations
	#
	belongs_to :brainbox

	# Thumbsup Gem 
	acts_as_voteable

	#
	# => Validations
	#
	validates :name, presence: true
	validates_uniqueness_of :name,	 	:scope => :brainbox_id,
  										:case_sensitive => false
	validates :content, presence: true

 	def cost(month, year)
 		date = Date.new(year, month, 01)
 		ppm = 5.0
 		if (self.created_at.year > year) || (self.created_at.year== year && self.created_at.month>month) #si l'utilisateur a été créé aprés le month/year son cout est nul pr ce mois
 			return 0
 		elsif (self.created_at.year < year) || (self.created_at.year==year && self.created_at.month<month)  #si l'utilisateur a été créé avant month son cout est ppm
 			return ppm #pri
 		elsif (self.created_at.month == month && self.created_at.year == year) #si l'utilisateur a été créé au cours de ce mois son cout est ppm au prorata
 			return ppm*((date.end_of_month.day.to_f - self.created_at.day.to_f)/ date.end_of_month.day)
 		end
 	end	

end
