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
end
