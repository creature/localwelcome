class Admin::InvitationsController < Admin::AdminController
  # Sends an invitation to a user (ie. accepts them to an event)
  def invite
   @invitation = Invitation.find(params[:id])

   if @invitation.send_invite!
     UserMailer.invite(@invitation).deliver_now
     flash[:notice] = "Invitation sent!"
   else
     flash[:alert] = "We couldn't send this invitation; maybe it's already been sent?"
   end
   redirect_to :back
  end

  def mark_as_attended
    @invitation = Invitation.find(params[:id])
    if @invitation.attended!
      redirect_to :back, notice: "Marked #{@invitation.user.email} as attended."
    else
      redirect_to :back, alert: "Couldn't mark #{@invitation.user.email} as attended."
    end
  end

  def mark_as_no_show
    @invitation = Invitation.find(params[:id])
    if @invitation.no_show!
      redirect_to :back, notice: "Marked #{@invitation.user.email} as a no-show."
    else
      redirect_to :back, alert: "Couldn't mark #{@invitation.user.email} as a no-show."
    end
  end
end
