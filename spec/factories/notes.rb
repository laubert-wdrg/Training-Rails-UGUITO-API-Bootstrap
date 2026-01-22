FactoryBot.define do
  factory :note do
    title { "MyString" }
    content { "MyText" }
    note_type { 1 }
    user { nil }
  end
end
