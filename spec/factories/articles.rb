# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "title_#{n}" }
    body "body"
    user

    factory :article_with_three_notifications do
      after_build do |article|
        3.times do
          article.notifications << FactoryGirl.build(:article_notification)
        end
      end
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
