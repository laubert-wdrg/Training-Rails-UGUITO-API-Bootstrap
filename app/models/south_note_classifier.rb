class SouthNoteClassifier
  def classify_content_length(note)
    return 'short' if note.word_count <= 60
    return 'medium' if note.word_count <= 120
    'long'
  end

  def max_review_words
    60
  end

  def exceeds_review_limit?(note)
    note.word_count > max_review_words
  end
end
