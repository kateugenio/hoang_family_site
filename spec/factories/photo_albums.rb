FactoryBot.define do
  factory :photo_album do
    name { "The Doggos" }
    description { "I love my dogs" }
    user { User.last || create(:user) }
    images { [] }

    factory :photo_album2 do
      name { "The Kiddos" }
      user { create(:user2) }
    end
  end
end
