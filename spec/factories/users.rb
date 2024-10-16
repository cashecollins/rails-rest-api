# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_user_#{n}@test.com" }
    name { "Tester McTestface" }
    sequence(:username) { |n| "test_user_#{n}" }
    password { "Password1!" }
    birth { "2000-01-01" }
  end
end
