# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "title"
    body "body"
    published true
    user

    factory :draft do
      published false
    end

    trait :with_stock do |article|
      after(:build) do |article|
        article.stocks << FactoryGirl.create(:stock)
      end
    end

    trait :with_tag do
      tag_list 'tag'
    end
  end
end
