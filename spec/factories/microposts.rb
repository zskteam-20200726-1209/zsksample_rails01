FactoryBot.define do
  factory :micropost do
    content { 'sample content' }
    association :user

    # 文字数が141文字
    trait :over_140 do
      content { 'a' * 141 }
    end
    # 文字数が140文字
    trait :just_140 do
      content { 'a' * 140 }
    end
    # 文字数が139文字
    trait :below_140 do
      content { 'a' * 139 }
    end
  end
end
