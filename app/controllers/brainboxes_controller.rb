class BrainboxesController < ApplicationController

	def destroy
		 @deleted_bb = Brainbox.find(params[:id])
 		 @deleted_bb.destroy

 		 redirect_to admin_path, notice: "Brainbox supprimée!"
 		 #Supprimer les idées
	end

	def add_idea
		@brainbox = Brainbox.where(id: idea_params[:brainbox_id]).take
		parameters = idea_params
		parameters[:account_id]=@brainbox.account_id
		@brainbox.ideas.build(parameters)
		if @brainbox.save
			redirect_to root_path, notice: "Idée Ajoutée!"
		else
			redirect_to root_path, alert: "Erreur lors de la création de l'idée!"
		end
	end


	private
		def idea_params
			params.require(:idea).permit(:name, :content, :brainbox_id)
		end

end
