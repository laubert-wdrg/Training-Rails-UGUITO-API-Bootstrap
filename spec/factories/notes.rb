FactoryBot.define do
  factory :note do
    title { "MyString" }
    content { "MyText" }
    note_type { :critique }
    user { association :user, utility: create(:north_utility) }
  end
end
