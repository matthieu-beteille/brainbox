# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :account do
    sequence(:subdomain){ |n| "subdomain#{n}" }
    association :owner, factory: :user
  end
end
