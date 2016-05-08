require 'forgery'
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

def create_dummy_articles(offset, dest)
  titles = Forgery(:lorem_ipsum).sentences(151).split(/(?:\.) /)
  paragraphs = Forgery(:lorem_ipsum).paragraphs(51).split("\n\n")
  offset.upto dest do |index|
    time = index.minutes.since
    Article.create(
      user_id: (1..5).to_a.sample,
      title: titles.sample,
      body: [
        paragraphs.sample,
        paragraphs.sample,
        paragraphs.sample
      ].join("\n\n"),
      tag_list: [Forgery('basic').color, Forgery('basic').color],
      created_at: time,
      updated_at: time
    )
  end
end

create_dummy_articles(1, 100)
