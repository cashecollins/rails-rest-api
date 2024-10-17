# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_user_#{n}@test.com" }
    name { "Tester McTestface" }
    password { "Password1!" }
  end
end
