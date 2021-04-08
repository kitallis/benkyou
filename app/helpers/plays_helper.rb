module PlaysHelper
  def card(question)
    question[:card]
  end

  def question(question)
    card(question).front
  end

  def attempted_answer(question)
    question[:attempted_answer].presence&.attempt
  end
end
