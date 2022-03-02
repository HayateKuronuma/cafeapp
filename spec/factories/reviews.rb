FactoryBot.define do
  factory :review do
    comment { "MyText" }
    title { "MyString" }
    user_id { 1 }
    shop_id { "MyString" }
  end
end
