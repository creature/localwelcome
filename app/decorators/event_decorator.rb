class EventDecorator < Draper::Decorator
  delegate_all

  def description
    field_helper(:description)
  end

  def email_info
    field_helper(:email_info)
  end

  def venue_name
    field_helper(:venue_name)
  end

  def venue_postcode
    field_helper(:venue_postcode)
  end

  def venue_info
    field_helper(:venue_info)
  end

  protected

  def field_helper(field)
    if object.public_send(field).blank?
      h.content_tag :span, "No #{field.to_s.humanize.downcase} yet", class: "system message"
    else
      object.public_send(field)
    end
  end
end
