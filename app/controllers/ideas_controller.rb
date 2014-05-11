class IdeasController < ApplicationController
	
	def initialize
	end

	def destroy
		 @deleted_idea = Idea.find(params[:id])
 		 @deleted_idea.destroy
 		 redirect_to admin_path, notice: "Idée supprimé !"
 		 #Supprimer les idées
	end

	def thumbs_up
		@idea = Idea.where(:id=> params[:id]).take
		if current_user.voted_for?(@idea) 
			current_user.unvote_for(@idea)
		elsif current_user.voted_against?(@idea)
			current_user.unvote_for(@idea)
			current_user.vote_for(@idea)
		else 
			current_user.vote_for(@idea)
		end

		redirect_to root_path
	end

	def thumbs_down
		@idea = Idea.where(:id => params[:id]).take
		if current_user.voted_against?(@idea)
			current_user.unvote_for(@idea)
		elsif current_user.voted_for?(@idea)
			current_user.unvote_for(@idea)
			current_user.vote_against(@idea)
		else
			current_user.vote_against(@idea)
		end	

		redirect_to root_path
	end

	private 
		def account_params
			params.require([:name, :content])
		end

end
