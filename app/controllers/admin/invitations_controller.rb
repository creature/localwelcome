class Admin::InvitationsController < Admin::AdminController
  load_and_authorize_resource

  # Sends an invitation to a user (ie. accepts them to an event)
  def invite
   if @invitation.send_invite!
     UserMailer.invite(@invitation).deliver_now
     flash[:notice] = "Invitation sent!"
   else
     flash[:alert] = "We couldn't send this invitation; maybe it's already been sent?"
   end
   redirect_to :back
  end

  def mark_as_attended
    if @invitation.attended!
      redirect_to :back, notice: "Marked #{@invitation.user.email} as attended."
    else
      redirect_to :back, alert: "Couldn't mark #{@invitation.user.email} as attended."
    end
  end

  def mark_as_no_show
    if @invitation.no_show!
      redirect_to :back, notice: "Marked #{@invitation.user.email} as a no-show."
    else
      redirect_to :back, alert: "Couldn't mark #{@invitation.user.email} as a no-show."
    end
  end

  def more_info_required
    if @invitation.user.update_attributes(more_info_required: true)
      UserMailer.more_info_required(@invitation).deliver_now
      redirect_to :back, notice: "We've emailed #{@invitation.user.name_or_email} and asked them to add more details to their profile."
    else
      redirect_to :back, alert: "An error occurred, and we couldn't ask #{@invitation.user.name_or_email} for more information."
    end
  end
end
