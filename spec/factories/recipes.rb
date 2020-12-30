FactoryBot.define do
  factory :recipe do
    name { 'Pumpkin Pie' }
    ingredients { 'ingredients' }
    directions { 'directions' }
    category { 'desserts' }
    serving_size { 4 }
    total_cook_time { 60 }
    user { User.last || create(:user) }
  end
end
