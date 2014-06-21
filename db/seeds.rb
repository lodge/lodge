# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

now = Time.now
User.create(email: 'user01@example.com', name: 'Kiske', password: 'password', confirmed_at: now)
User.create(email: 'user02@example.com', name: 'Hansen', password: 'password', confirmed_at: now)
User.create(email: 'user03@example.com', name: 'Meyer', password: 'password', confirmed_at: now)
User.create(email: 'user04@example.com', name: 'Ward', password: 'password', confirmed_at: now)
User.create(email: 'user05@example.com', name: 'Zafiriou', password: 'password', confirmed_at: now)


20.times do |index|
  Article.create(title: "test #{index}", body: "# body #{index}", user_id: 1, tag_list: ["Rails", "Ruby"]);
end

21.upto 40 do |index|
  Article.create(title: "test #{index}", body: "# body #{index}", user_id: 2, tag_list: ["Git"]);
end

41.upto 60 do |index|
  Article.create(title: "test #{index}", body: "# body #{index}", user_id: 3, tag_list: ["Java", "PHP", "Go", "Python"]);
end

61.upto 80 do |index|
  Article.create(title: "test #{index}", body: "# body #{index}", user_id: 4, tag_list: ["Google", "Amazon"]);
end

81.upto 100 do |index|
  Article.create(title: "test #{index}", body: "# body #{index}", user_id: 5, tag_list: ["Java", "PHP", "Go", "Python"]);
end
