class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:accept, :decline]
  before_action :check_for_more_info_required

  def create
    @invite = Invitation.new(invitation_params.merge(user: current_user))
    if @invite.save
      redirect_to :back, notice: "Invitation requested!"
    else
      redirect_to :back, alert: "Sorry, something went wrong: #{@invite.errors.full_messages.join(", ")}"
    end
  end

  def update
  end

  def destroy
    @invite = Invitation.find(params[:id])
    if @invite.destroy
      redirect_to :back, notice: "Invitation removed. Sorry that you can't make it."
    else
      redirect_to :back, alert: "Sorry, something went wrong."
    end
  end

  # Gives a user a one-click accept within an invite email
  def accept
    @invite = Invitation.find_by_token(params[:token])
    if @invite.accept_invite!
      redirect_to chapter_event_path(@invite.event.chapter, @invite.event), notice: "Your place is confirmed. See you there!"
    else
      redirect_to chapter_event_path(@invite.event.chapter, @invite.event), alert: "Sorry, we couldn't reserve you a place at this meeting."
    end
  end

  # Gives a user a one-click decline within an invite email
  def decline
    @invite = Invitation.find_by_token(params[:token])
    @invite.decline_invite!
    redirect_to chapter_event_path(@invite.event.chapter, @invite.event), notice: "Thanks for letting us know that you can't make it."
  end

  protected

  def invitation_params
    params.require(:invitation).permit(:event_id, :who_do_you_want_to_meet)
  end

  def check_for_more_info_required
    redirect_to edit_profile_path if current_user.try(:more_info_required?)
  end
end
