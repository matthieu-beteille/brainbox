Timetracker::Application.routes.draw do
	

#Routes dans le cas de la page d'accueil sans sous-domaine
	constraints(NoSubdomainRoute) do
		match '/signup', to: 'accounts#new', via: 'get'
		match '/accounts', to: 'accounts#create', via: 'post'
		root to: "welcome#index", as: "root"
	end

#Routes dans le cas d'un sous-domaine
	constraints(SubdomainRoute) do		
		devise_for :users
		
		devise_scope :user do
		#	root :to => 'devise/sessions#new', as: 'subdomain_root'
			root :to =>'accounts#show', as: 'subdomain_root'
			match '/admin', to: 'accounts#admin', via: 'get'
			match '/add_user', to: 'accounts#add_user', via: 'post'
			match '/add_user', to: 'accounts#add_user', via: 'post'
			match '/add_bb', to: 'accounts#add_bb', via: 'post'
			match '/add_idea', to: 'brainboxes#add_idea', via: 'post'
			match '/facture', to: 'accounts#facture', via: 'post'
			match '/change_subscription_type', to: 'accounts#change_subscription_type', via: 'post'
		end	
		#match '/accounts/:id', to: 'accounts#new', via: 'get'
		resources :accounts,  only: [:index, :new, :create, :show] do
			resources :users,  only: [:destroy]
			resources :brainboxes,  only: [:destroy]
		end

		resources :brainboxes,  only: [:destroy] do 
			resources :ideas,  only: [:show] 
		end

		resources :ideas,  only: [:show] do
				post 'thumbs_up', on: :member
				post 'thumbs_down', on: :member
		end

	end

 

end
