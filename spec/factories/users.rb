FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name  { 'Snow' }
    email { 'jsnow@test.com' }
    password { 'password123' }
    admin { false }
    approved { true }

    factory :admin do
      admin { true }
      email { 'admin@admin.com' }
      first_name { 'Admin' }
      last_name { 'User' }
    end

    factory :user2 do
      first_name { 'Billy' }
      last_name  { 'Bob' }
      email { 'bbob@test.com' }
    end
  end
end
