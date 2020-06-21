FactoryBot.define do
  factory :user do
    email { "test#{SecureRandom.hex(12)}@test.com" }
    password { Devise.friendly_token.first(13).squeeze }
  end
end
