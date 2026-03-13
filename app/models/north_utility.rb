class NorthUtility < Utility
  def content_length_thresholds
    { short: 50, medium: 100 }
  end

  def max_review_words
    50
  end
end
