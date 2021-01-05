FactoryBot.define do
  factory :comment do
    comment { "I love this recipe" }
    user { User.last || create(:user) }
    association :commentable, factory: :recipe
  end
end
