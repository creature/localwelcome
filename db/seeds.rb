# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

london = Chapter.create(name: 'London', description: Faker::Lorem.paragraph)
Chapter.create(name: 'Birmingham', description: Faker::Lorem.paragraph)
Chapter.create(name: 'Manchester', description: Faker::Lorem.paragraph)

5.times do |i|
  i -= 2
  Event.create(chapter: london, title: Faker::Lorem.sentence, starts_at: i.months.from_now, ends_at: i.months.from_now + 2.hours)
end

5.times do
  user = User.new(
    name:     Faker::Name.first_name,
    email:    Faker::Internet.email,
    password: Faker::Lorem.characters(10),
  )
  user.save!
end

admin = User.new(
  name:     "localwelcome-admin",
  email:    "admin@localwelcome.com",
  password: "localwelcome",
)
admin.save!

admin_role = Role.new(
  user: admin,
  chapter: nil,
  role: "admin"
)
admin_role.save!

puts "Chapters count: #{Chapter.count}"
puts "Events count: #{Event.count}"
puts "Users count: #{User.count}"
puts "Roles count: #{Role.count}"
