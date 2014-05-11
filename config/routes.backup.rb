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
			match '/idea/thumbs_up/a', to: 'ideas#add_thumbs_up', via: 'post'
			match '/idea/thumbs_down/', to: 'ideas#add_thumbs_down', via: 'post'
			#match '/delete_user', to: 'users#delete_user', via: 'delete'
			#match '/delete_brainbox', to: 'brainboxes#delete_brainbox', via: 'delete'
		end	
		#match '/accounts/:id', to: 'accounts#new', via: 'get'
		resources :accounts,  only: [:index, :new, :create, :show] 
		resources :users,  only: [:destroy]
		resources :brainboxes,  only: [:destroy]
		resources :ideas,  only: [:show]
	end

 

end
