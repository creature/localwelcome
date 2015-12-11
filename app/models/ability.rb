class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :read, Chapter
      can :read, Event
      can :manage, User, id: user.id

      if user.admin?
        can :manage, :all
      end

      if user.organiser?
        can :manage, Chapter, id: user.organised_chapters.ids
        cannot :create, Chapter
        can :manage, Event, chapter_id: user.organised_chapters.ids
      end
    end
  end
end
