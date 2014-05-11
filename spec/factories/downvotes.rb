# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :downvote do
    user_id 1
    account_id 1
    idea_id 1
  end
end
