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
  delegate :utility, to: :user

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
    utility.note_classifier.classify_content_length(self)
  end

  private

  def set_utility_from_user
    self.utility = user.utility if user.present? && utility.blank?
  end

  def content_word_limit
    return unless review? && content.present?
    classifier = utility.note_classifier
    return unless classifier.exceeds_review_limit?(self)

    errors.add(:content, I18n.t('note.attributes.content.review_word_limit',
                                max_words: classifier.max_review_words))
  end
end
