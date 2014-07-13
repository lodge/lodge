# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "title"
    body "body"
    user

    factory :edited_article do
      old_title "old_title"
      old_body "old_body"
      old_tags "old_tag1,old_tag2"
      new_tags "new_tag1,new_tag2"
    end

    factory :article_with_three_notifications do
      after_build do |article|
        3.times do
          article.notifications << FactoryGirl.build(:article_notification)
        end
      end
    end
  end
end
