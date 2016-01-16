# Fill out the various fields of a datetime helper in one go.
def datetime_select(field, datetime)
  select datetime.day, from: "#{field}_3i"
  select datetime.strftime("%B"), from: "#{field}_2i"
  select datetime.year, from: "#{field}_1i"
  select datetime.strftime("%H"), from: "#{field}_4i"
  select datetime.strftime("%M"), from: "#{field}_5i"
end

# Fill in the "Add new event" form on the admin panel.
def fill_in_event_form(name, description, starts_at, ends_at)
  fill_in :event_name, with: name
  fill_in :event_description, with: description
  datetime_select(:event_starts_at, starts_at)
  datetime_select(:event_ends_at, ends_at)
end

# A helper that checks if a given button is or isn't displayed for a given page.
def check_for_manage_button(u, path, name, should_see_link)
  logout(:user)
  login_as(u)
  visit path

  if should_see_link
    expect(page).to have_link "Manage this #{name}"
  else
    expect(page).not_to have_link "Manage this #{name}"
  end
end

def check_for_manage_event_button(u, event, should_see_link)
  check_for_manage_button(u, chapter_event_path(event.chapter, event), "event", should_see_link)
end

def check_for_manage_chapter_button(u, chapter, should_see_link)
  check_for_manage_button(u, chapter_path(chapter), "chapter", should_see_link)
end
