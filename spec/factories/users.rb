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
  end
end
