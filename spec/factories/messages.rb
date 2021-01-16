FactoryBot.define do
  factory :message do
    subject { 'Hello family' }
    body { 'Lets plan a summer vacation' }
    user { User.last || create(:user) }

    factory :message2 do
      subject { 'Photos have been uploaded' }
      body { 'Check our the vacation photos' }
      user { create(:user2) }
    end
  end
end
