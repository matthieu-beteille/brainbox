class AccountsController < ApplicationController
	#
	# => TODO : un meme email doit pouvoir être utiliser sur deux domaines différents
	# => Sécurité : enlever le rôle de l'hidden field et le définir à l'interieur du contrôleur
	#


	# Requiert l'identification sauf pour certaines méthodes
	before_filter :authenticate_user!, except: [:new, :create]
	authorize_resource :only => [:admin, :add_user, :remove_user]

	before_filter :get_current_account, :only =>[:show, :admin, :add_user, :add_bb, :facture, :change_subscription_type]


	def get_current_account
		@current_account = Account.where(subdomain: request.subdomain).take
	end

	def new
		#Création du compte
		@account = Account.new
		#Création de l'owner associé		
		@account.build_owner
	end

	def create	
		parameters = account_params
		@account = Account.new(parameters)
		@account.build_owner(parameters[:owner_attributes])
		# essaye avec build_owner puis save aprés la sauvegarde l'account
		if @account.save	
			#if 	@account.create_owner(parameters[:owner_attributes])
				redirect_to root_path, notice: "Signed up successfully ! Go on #{parameters[:subdomain]}.brainbox.dev to sign-in your new BrainBox !"
			#else
			# 	@account.destroy
			#	render action: 'new'
			#end
		else
			render action: 'new'
		end
	end

	def show
		#@account = Account.where(subdomain: request.subdomain).take
		@bbs = Brainbox.where(account_id: @current_account.id)
		#Idea form
		@idea = Idea.new
	end
	
	def index
	end
	
	def admin
		@account = Account.new
		#User form
		@user = User.new		
		@user = @current_account.users.build
		#Liste des users paginée
		@users = User.where(account_id: @current_account.id).paginate(page: params[:users_page], :per_page => 5)
		#Liste de tous les users
		@all_users = User.where(account_id: @current_account.id)
		#Liste des users supprimés
		@deleted_users = User.where(account_id: @current_account.id).only_deleted
		#BB form
		@bb = Brainbox.new
		@bb = @current_account.brainboxes.build
		#Liste des bbs paginée
		@bbs = Brainbox.where(account_id: @current_account.id).paginate(page: params[:bbs_page], :per_page => 5)
		#Liste de toutes les bbs
		@all_bbs = Brainbox.where(account_id: @current_account.id)	
		#Liste des bbs supprimés
		@deleted_bbs = Brainbox.where(account_id: @current_account.id).only_deleted
		#Nombre d'idées totales du compte, de thumbs up et down totaux
		@ideas=0
		@thumbs_up=0
        @thumbs_down=0
        @bbs.each do |bb|
            @ideas += bb.ideas.size
            bb.ideas.each do |i| 
	      	 	@thumbs_up += i.votes_for
	        	@thumbs_down += i.votes_against
	    	 end
        end

	end

	def add_user	
		if @current_account.users.size < @current_account.users_max	|| @current_account.subscription_type == 'payasyougo'
			@current_account.users.build(user_params)
			if @current_account.save
				if @current_account.users.size >= @current_account.users_max - 2
						Emailer.max_users(@current_account.owner).deliver if @current_account.users.size == @current_account.users_max
						Emailer.warning_users(@current_account.owner).deliver if @current_account.users.size < @current_account.users_max
				end
				redirect_to admin_path , notice: "Utilisateur créé"
			else
				redirect_to admin_path, alert: "Erreur lors de la création de l'utilisateur"
				#flash[:errors]=@current_account.errors
				#render action: 'adm'
			end
		else
			redirect_to admin_path, alert: "Nombre maximal d'utilisateurs atteint pour un compte #{@current_account.subscription_type}"
		end

	end

	def add_bb
		if @current_account.brainboxes.size < @current_account.bbs_max || @current_account.subscription_type == 'payasyougo'
			@bb = @current_account.brainboxes.build(bb_params)
			if @current_account.save
				if @current_account.brainboxes.size >= @current_account.bbs_max - 2
						Emailer.max_bbs(@current_account.owner).deliver if @current_account.brainboxes.size == @current_account.bbs_max
						Emailer.warning_bbs(@current_account.owner).deliver if @current_account.brainboxes.size < @current_account.bbs_max
				end
				redirect_to admin_path, notice: "BrainBox créée"
			else
				redirect_to admin_path, alert: "Erreur lors de la création de la BrainBox"
			end	
		else
			redirect_to admin_path, alert: "Nombre maximal de Brainboxes atteint pour un compte #{@current_account.subscription_type}"
		end
	end

	def facture
		@month = params[:date][:month]
		@year = params[:date][:year]
		@all_users = User.where(account_id: @current_account.id)
		@deleted_users = User.where(account_id: @current_account.id).only_deleted
		@all_bbs = Brainbox.where(account_id: @current_account.id)	
		@deleted_bbs = Brainbox.where(account_id: @current_account.id).only_deleted

		respond_to do |format|   
    		  format.js   {}    
 		 end
	end

	def change_subscription_type
		@current_account.subscription_type = account_params[:subscription_type]
		if @current_account.save
			redirect_to admin_path, notice: "Changement de souscription effectuée. Vous disposez maintenant d'un compte #{@current_account.subscription_type.capitalize} ! "
		else 
			redirect_to admin_path, warning: "Erreur lors du changement de souscription"
		end
	end


	private 
		def account_params
			params.require(:account).permit(:subdomain, :subscription_type, owner_attributes: [:name, :role, :email, :password, :password_confirmation])
		end

	private
		def user_params
			params.require(:user).permit(:name, :role, :email, :password, :password_confirmation)
		end

	private
		def bb_params
			params.require(:brainbox).permit(:name, :descr)
		end

	
end
