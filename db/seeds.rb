# Create some chapters
london = Chapter.find_or_create_by(name: 'London', description: Faker::Lorem.paragraph)
Chapter.find_or_create_by(name: 'Birmingham', description: Faker::Lorem.paragraph)
Chapter.find_or_create_by(name: 'Manchester', description: Faker::Lorem.paragraph)

# Make sure that London has some events
5.times do |i|
  i -= 2
  Event.find_or_create_by(chapter: london, title: Faker::Lorem.sentence, starts_at: i.months.from_now, ends_at: i.months.from_now + 2.hours)
end

# Create some users
5.times do
  email = Faker::Internet.safe_email
  unless User.where(email: email).exists?
    u = User.new(name: Faker::Name.first_name, email: email, password: Faker::Lorem.characters(10))
    u.save
  end
end

# Ensure that an admin user exists
unless admin = User.find_by(email: "admin@example.com")
  admin = User.new(name: "admin", email: "admin@example.com", password: "password")
  admin.save
end
Role.find_or_create_by(user: admin, chapter: nil, role: "admin")

puts "Chapters count: #{Chapter.count}"
puts "Events count: #{Event.count}"
puts "Users count: #{User.count}"
puts "Roles count: #{Role.count}"
