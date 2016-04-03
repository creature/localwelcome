class EventDecorator < Draper::Decorator
  include ApplicationHelper # This works around some Draper weirdness when using proxied helpers in mailers. Don't call @event.render_markdown.
  delegate_all

  def friendly_description
    field_helper(:description, true)
  end

  def friendly_text_description
    field_helper_as_text(:description)
  end

  def email_info
    field_helper(:email_info, true)
  end

  # Email info is optional; render the Markdown, if we have it.
  def optional_email_info_as_text
    render_markdown_as_text(object.email_info) unless object.email_info.blank?
  end

  def venue_name
    field_helper(:venue_name)
  end

  def venue_postcode
    field_helper(:venue_postcode)
  end

  def venue_info
    field_helper(:venue_info, true)
  end

  # `venue_info` will render a "No venue info yet" tag if it's missing; this one will just output nothing.
  def optional_venue_info
    render_markdown(object.venue_info) unless object.venue_info.blank?
  end

  def optional_venue_info_as_text
    render_markdown_as_text(object.venue_info) unless object.venue_info.blank?
  end

  def friendly_venue_name
    if !object.venue_name.blank? && !object.venue_postcode.blank?
      "#{venue_name}, #{venue_postcode}"
    elsif !object.venue_name.blank?
      venue_name
    elsif !object.venue_postcode.blank?
      "(Not announced yet), #{venue_postcode}"
    else
      "Not announced yet"
    end
  end

  def google_map_url
    if !object.venue_name.blank? && !object.venue_postcode.blank?
      query_param = "#{venue_name}, #{venue_postcode}"
    elsif !object.venue_name.blank? || !object.venue_postcode.blank?
      query_param = "#{object.venue_name}#{object.venue_postcode}"
    end
    "https://maps.google.com/?q=" + h.u(query_param)
  end

  protected

  # Display the field if it's not blank, otherwise render <span class="system message">No [fieldname] yet</span>.
  # Optionally supports Markdown.
  def field_helper(field, markdown=false)
    if object.public_send(field).blank?
      h.content_tag :span, "No #{field.to_s.humanize.downcase} yet", class: "system message"
    elsif markdown
      render_markdown object.public_send(field)
    else
      object.public_send(field)
    end
  end
end
