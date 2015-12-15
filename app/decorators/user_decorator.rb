class UserDecorator < Draper::Decorator
  delegate_all

  def popover_preview
    h.render partial: "admin/users/popover_preview", object: self
  end

  def admin_link_with_popover(chapter=nil)
    common_opts = { data: { toggle: "popover", content: h.html_escape_once(popover_preview) }, title: name, class: "popoverable" }
    if chapter
      h.link_to name, h.admin_chapter_user_path(chapter, object), data: common_opts
    else
      h.link_to name, h.admin_user_path(object), common_opts
    end
  end

  def name
    if object.name.blank?
      object.email
    else
      object.name
    end
  end

  def optional_name
    field_helper(:name)
  end

  def bio
    field_helper(:bio)
  end

  def telephone
    field_helper(:telephone)
  end

  def postcode
    field_helper(:postcode)
  end

  def life_skills
    field_helper(:life_skills)
  end

  def language_skills
    field_helper(:language_skills)
  end

  protected

  def field_helper(field)
    if object.public_send(field).blank?
      h.content_tag :span, "Not set", class: "system message"
    else
      object.public_send(field)
    end
  end
end
