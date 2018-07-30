User.create!(name: "Example User", email: "example@railstutorial.org",
  password: "123456", password_confirmation: "123456", role: 1,
  activated: true, activated_at: Time.zone.now)

100.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, password: password,
    password_confirmation: password, activated: true, role: Faker::Number.between(0,1),
    activated_at: Time.zone.now)
end
Category.destroy_all
10.times do
  Category.create(name: Faker::Dog.name, trademark: Faker::Name.name)
end
200.times do
  Shoe.create(name: Faker::Dog.name, quantity: Faker::Number.between(1, 25),
    price: Faker::Commerce.price, description: Faker::Lorem.paragraphs,
    img_url: Faker::Avatar.image, category_id: Faker::Number.between(1, 10))
end
20.times do
  Discount.create!(start_date: Faker::Date.between(10.days.ago, Date.today),
    end_date: Faker::Date.between(1.days.ago, Date.today),
    percent: Faker::Number.between(0, 100),
    shoe_id: rand(1..20))
end
