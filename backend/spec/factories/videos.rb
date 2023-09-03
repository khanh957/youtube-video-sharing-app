FactoryBot.define do
  factory :video do
    sequence(:url) { |n| "https://www.youtube.com/watch?v=#{n + 100}" }
    sequence(:video_id) { |n| n + 100 }
    sequence(:title) { |n| "video #{n}" }
    description { "description" }
    created_at { Time.current }

    association :user
  end
end
