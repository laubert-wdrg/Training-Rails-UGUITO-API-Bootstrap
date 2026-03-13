class SouthUtility < Utility
  def content_length_thresholds
    { short: 60, medium: 120 }
  end

  def max_review_words
    60
  end
end
