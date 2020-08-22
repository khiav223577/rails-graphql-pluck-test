FactoryBot.define do
  factory :item do
    sequence(:title) { |n| "item-#{n}" }
    user { create(:user) }
  end
end
