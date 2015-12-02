class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif user
      can :manage, User, id: user.id
    end
  end
end
