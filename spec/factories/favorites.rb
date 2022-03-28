FactoryBot.define do
  factory :favorite do
    shop_id { "J001245046" }

    association :user
  end
end
