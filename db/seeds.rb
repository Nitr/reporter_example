# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

5.times.each do |user_number|
  user = User.create!(name: "User #{user_number}")

  10.times.each do |i|
    user.orders.create!(name: "Order #{i}", price: rand(1.0..100.0), amount: rand(1..10))
  end
end
