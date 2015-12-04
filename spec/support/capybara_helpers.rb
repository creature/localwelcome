def datetime_select(field, datetime)
  select datetime.day, from: "#{field}_3i"
  select datetime.strftime("%B"), from: "#{field}_2i"
  select datetime.year, from: "#{field}_1i"
  select datetime.hour, from: "#{field}_4i"
  select datetime.strftime("%M"), from: "#{field}_5i"
end
