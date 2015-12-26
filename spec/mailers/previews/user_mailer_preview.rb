class UserMailerPreview < ActionMailer::Preview
  def invite_with_no_extra_info
    invite = Invitation.first
    %i{email_info venue_name venue_postcode venue_info}.each { |s| invite.event.public_send("#{s}=", nil) }

    UserMailer.invite(invite)
  end

  def invite_with_email_info
    invite = Invitation.first
    %i{venue_name venue_postcode venue_info}.each { |s| invite.event.public_send("#{s}=", nil) }
    invite.event.email_info = "We've got these extra details to tell you, because you're invited."
    UserMailer.invite(invite)
  end

  def invite_with_venue_info_only
    invite = Invitation.first
    invite.event.email_info = nil
    invite.event.venue_name = "Starbucks"
    invite.event.venue_postcode = "SW1E 6RD"
    invite.event.venue_info = "Upstairs, on a table with a 'Local Welcome' sign."
    UserMailer.invite(invite)
  end

  def invite_with_all_extra_info
    invite = Invitation.first
    invite.event.email_info = "Here's some details for you, just as an attendee."
    invite.event.venue_name = "Starbucks"
    invite.event.venue_postcode = "SW1E 6RD"
    invite.event.venue_info = "Upstairs, on a table with a 'Local Welcome' sign."
    UserMailer.invite(invite)
  end
end
