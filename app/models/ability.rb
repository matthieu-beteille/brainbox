class Ability
include CanCan::Ability
 
 #
 # Ici sont définies les autorisations, les accés
 #
  def initialize(user)
    if user.role=='admin' 
      can :manage, :all
   elsif user.role=='user'
      cannot :admin, Account    
 	 end
 end

end
