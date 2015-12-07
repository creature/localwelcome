# Links a user and an event. Keeps track of whether we've sent them an invite, whether they turned up, etc.
class Invitation < ActiveRecord::Base
  include AASM # Acts As State Machine

  belongs_to :user
  belongs_to :event

  validates :user, presence: true, uniqueness: { scope: :event }
  validates :event, presence: true

  enum aasm_state: [:requested, :sent, :accepted, :declined, :cancelled, :unknown, :attended, :no_show, :cancelled_politely, :cancelled_rudely]

  aasm whiny_transitions: false do
    state :requested, initial: true # An invite has been requested
    state :sent # Sent an invite to the user
    state :accepted # User has said they're coming
    state :declined # User was sent an invite, but can't make it
    state :cancelled # The invitation was sent to the user, but an organiser revoked it
    state :unknown # We don't know if the user showed up or not
    state :attended # The user came along to our event
    state :no_show # The user RSVPed yes, but didn't turn up
    state :cancelled_politely # The user dropped out with lots of notice
    state :cancelled_rudely # The user dropped out at late notice

    event(:send_invite) { transitions from: :requested, to: :sent }
    event(:accept_invite) { transitions from: :sent, to: :accepted }
    event(:decline_invite) { transitions from: [:sent, :accepted], to: :declined }
    event(:unknown) { transitions from: :accepted, to: :unknown }
    event(:attended) { transitions from: :accepted, to: :attended }
    event(:no_show) { transitions from: :accepted, to: :no_show }
    event(:cancelled_politely) { transitions from: :accepted, to: :cancelled_politely }
    event(:cancelled_rudely) { transitions from: :accepted, to: :cancelled_rudely }
    event(:cancelled_by_admin) { transitions from: [:sent, :accepted], to: :cancelled }
  end

  # Gets a token that can be used to update this invite.
  def token
    Invitation.verifier.generate [user.email, id, created_at]
  end

  # Gets an invite via a token.
  def self.find_by_token(token)
    email, id, created_at = Invitation.verifier.verify(token)
    Invitation.find(id)
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  protected

  def self.verifier
    @@verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
  end
end
