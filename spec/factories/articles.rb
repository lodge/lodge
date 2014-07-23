# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "title"
    body "body"
    user

    factory :article_with_three_notifications do
      after_build do |article|
        3.times do
          article.notifications << FactoryGirl.build(:article_notification)
        end
      end
    end
  end
end
