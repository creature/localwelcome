# Keeps track of user permissions. Users can be regular users (ie. they have no Roles), chapter organisers, or admins.
class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :chapter

  enum role: [:admin, :chapter_organiser]

  validates :user, presence: true
  validates :role, presence: true
  validates :chapter, presence: true, if: :chapter_organiser?
end
