# == Schema Information
#
# Table name: notes
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  content    :text
#  note_type  :integer
#  user_id    :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  utility_id :bigint(8)        not null
#
class Note < ApplicationRecord
  belongs_to :user
  belongs_to :utility

  before_validation :set_utility_from_user

  enum type: { critique: 1, review: 2 }

  validates :type, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validate :content_word_limit

  def word_count
    return 0 if content.blank?
    content.split.size
  end

  def content_length
    word_count_value = word_count
    thresholds = utility.content_length_thresholds

    return 'short' if word_count_value <= thresholds[:short]
    return 'medium' if word_count_value <= thresholds[:medium]
    'long'
  end

  private

  def set_utility_from_user
    self.utility = user.utility if user.present? && utility.blank?
  end

  def content_word_limit
    return unless review? && content.present?

    word_count_value = word_count
    max_words = utility.max_review_words

    if word_count_value > max_words
      errors.add(:content, I18n.t('note.attributes.content.review_word_limit', 
                                  utility: utility.clean_name, 
                                  max_words: max_words))
    end
  end
end
