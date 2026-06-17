FactoryBot.define do
  factory :note do
    title { "MyString" }
    content { "MyText" }
    note_type { Note.note_types.keys.sample }
    user
  end
end
