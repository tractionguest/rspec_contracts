# frozen_string_literal: true

FactoryBot.define do
  factory :pet do
    sequence(:name) {|n| "pet#{n}" }
    sequence(:tag) {|n| "tag#{n}" }
  end
end
