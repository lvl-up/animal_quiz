class Question
  attr_accessor :yes, :no, :parent
  attr_reader :question

  def initialize question, parent = nil
    @question, @parent = question, parent
  end

  def answer answer
    answer == YES ? @yes : @no
  end

  def insert question, final_answer
    final_answer == YES ? self.yes = question : self.no = question
    question.parent = self
  end

  def to_s
    @question
  end
  
  
end
