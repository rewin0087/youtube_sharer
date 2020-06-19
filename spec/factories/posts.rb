FactoryBot.define do
  factory :post do
    title { "MyString" }
    youtube_url { "MyString" }
    description { "MyText" }
    user { nil }
  end
end
