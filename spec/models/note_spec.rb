require 'rails_helper'

describe Note, type: :model do
  subject(:note) { build(:note) }

  describe "validations and associations" do
    it { is_expected.to belong_to(:user) }
    
    it "requires utility to be present" do
      expect(note.utility).not_to be_nil
    end
    
    it { is_expected.to validate_presence_of(:note_type) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end
  
  describe "enums" do
    it { is_expected.to define_enum_for(:note_type).with_values(critique: 1, review: 2) }
  end

  describe "#word_count" do
    it "returns the exact number of words in the content" do
      note.content = "Lorem ipsum dolor sit amet"
      expect(note.word_count).to eq(5)
    end
  end

  describe "#content_length" do
    it "returns 'short' for content under the threshold" do
      note.content = "Test " * 22
      expect(note.content_length).to eq("short")
    end

    it "returns 'long' for content over the threshold" do
      note.content = "Test " * 120
      expect(note.content_length).to eq("long")
    end
  end

  describe "Utility-specific validations" do
    context "when the utility is North" do
      let(:north_utility) { create(:north_utility) }
      let(:north_user) { create(:user, utility: north_utility) }
      
      it "is invalid if a review exceeds the word limit" do
        invalid_note = build(:note, content: "Test " * 120, note_type: :review, user: north_user)
        expect(invalid_note).to_not be_valid
      end
      
      it "is valid if a critique exceeds the review word limit" do
        valid_note = build(:note, content: "Test " * 120, note_type: :critique, user: north_user)
        expect(valid_note).to be_valid
      end
    end
    
    context "when the utility is South" do
      let(:south_utility) { create(:south_utility) }
      let(:south_user) { create(:user, utility: south_utility) }
      
      it "is valid if a review is within the specific South limit" do
        valid_note = build(:note, content: "Test " * 50, note_type: :review, user: south_user)
        expect(valid_note).to be_valid
      end

      it "is invalid if a review exceeds the specific South limit" do
        invalid_note = build(:note, content: "Test " * 61, note_type: :review, user: south_user)
        expect(invalid_note).to_not be_valid
      end
    end
  end
end