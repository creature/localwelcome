# Links a user and an event. Keeps track of whether we've sent them an invite, whether they turned up, etc.
class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  enum status: [:no_show, :attended, :late_notice_drop_out, :polite_change_of_plans]

  validates :user, presence: true, uniqueness: { scope: :event }
  validates :event, presence: true
end
