FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "TestTitle#{n}" }
    comment { "TestComment" }
    shop_id { "J001245046" }
    shop_name { "TestShop1" }
    rate { rand(1..5) }

    association :user
  end
end
