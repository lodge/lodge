# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:name) {|n| "John Doe #{n}" }
  sequence(:email) {|n| "john.doe.#{n}@example.com" }

  factory :user do
    name
    email
    password "password"
    confirmed_at Time.zone.now
  end
end
