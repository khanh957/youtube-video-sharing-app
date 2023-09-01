FactoryBot.define do
  factory :user do
    email { "email@example.com" }
    password { "password" }
    created_at { Time.current }
  end
end
