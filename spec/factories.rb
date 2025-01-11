FactoryBot.define do
  factory(:user) do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "#{n}#{Faker::Internet.email}" }
    password { 'password123' }
    password_confirmation { 'password123' }
  end

  factory :blog_post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    publication_date { Date.today }
    association :user, factory: :user
  end

  factory :comment do
    content { Faker::Lorem.paragraph }
    association :blog_post, factory: :blog_post
    association :user, factory: :user
  end
end