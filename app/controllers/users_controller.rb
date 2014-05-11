class UsersController < ApplicationController

	def destroy
		@deleted_user = User.find(params[:id])
 		 @deleted_user.destroy
 		 redirect_to admin_path, notice: "Utilisateur supprimé !"
	end


	private 
		def account_params
			params.require([:name, :email, :role, :password, :password_confirmation])
		end

end
