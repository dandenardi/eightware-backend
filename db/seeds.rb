
if Rails.env.development?
  puts "Creating sample users..."


  admin = User.find_or_create_by(email: 'admin@example.com') do |user|
    user.first_name = 'Admin'
    user.last_name = 'User'
    user.password = 'password123'
    user.password_confirmation = 'password123'
  end


  5.times do |i|
    User.find_or_create_by(email: "user#{i + 1}@example.com") do |user|
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.password = 'password123'
      user.password_confirmation = 'password123'
    end
  end

  puts "Sample users created!"
  puts "Admin: admin@example.com / password123"
  puts "Users: user1@example.com to user5@example.com / password123"
end