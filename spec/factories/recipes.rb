FactoryBot.define do
  factory :recipe do
    name { "MyString" }
    ingredients { "MyText" }
    directions { "MyText" }
    category { "MyString" }
    user { nil }
  end
end
