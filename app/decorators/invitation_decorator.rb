class InvitationDecorator < Draper::Decorator
  delegate_all

  def friendly_status
    return "More profile information requested" if object.user.more_info_required?
    return "Invitation requested" if object.requested?
    return "Invitation sent, no response yet" if  object.sent?
    return "Not attending" if object.declined?
    return "Attending" if object.accepted?
    return "Invitation cancelled" if object.cancelled?
    return "Attended" if object.attended?
    return "No-show" if object.no_show?
  end

  def user
    object.user.decorate
  end
end
