FactoryBot.define do
  factory :comment do
    comment { "I love this recipe" }
    user { User.last || create(:user) }
    association :commentable, factory: :recipe

    factory :message_comment do
      comment { "Great post" }
      user { User.last || create(:user) }
      association :commentable, factory: :message
    end
  end
end
