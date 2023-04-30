FactoryBot.define do
  factory :doc do
    sequence(:title) { |n| "Sample Document #{n}" }
    content { "This is a sample document." }
    sequence(:slug) { |n| "sample-document-#{n}" }

    trait :with_password do
      password { "securepassword" }
      password_confirmation { "securepassword" }
    end

    trait :without_password do
      password { nil }
      password_confirmation { nil }
    end
  end
end
