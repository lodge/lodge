# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "title_#{n}" }
    body 'body'
    published true
    is_public_editable false
    sequence(:created_at) { |n| n.minute.since }
    sequence(:updated_at) { |n| n.minute.since }
    user

    factory :draft do
      published false
    end

    trait :with_stock do
      after(:create) do |a|
        a.stocks.create(user_id: a.user.id)
      end
    end

    trait :with_tag do
      tag_list 'tag'
    end
  end
end
