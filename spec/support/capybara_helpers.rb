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
