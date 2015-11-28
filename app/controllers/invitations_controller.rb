class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @invite = Invitation.new(invitation_params.merge(user: current_user))
    if @invite.save
      redirect_to :back, notice: "Invitation requested!"
    else
      redirect_to :back, alert: "Sorry, something went wrong."
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

  protected

  def invitation_params
    params.require(:invitation).permit(:event_id)
  end
end
