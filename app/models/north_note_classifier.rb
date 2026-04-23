class NorthNoteClassifier
  def classify_content_length(note)
    return 'short' if note.word_count <= 50
    return 'medium' if note.word_count <= 100
    'long'
  end

  def max_review_words
    50
  end

  def exceeds_review_limit?(note)
    note.word_count > max_review_words
  end
end
