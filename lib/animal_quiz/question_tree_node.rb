module AnimalQuiz
  YES = 'y'
  NO = 'n'

  class QuestionTreeNode
    attr_accessor :parent
    attr_reader :value, :right, :left

    def initialize value
      @value = value
    end

    def answer answer
      answer == YES ? @right : @left
    end

    def next answer_to_question
      answer_to_question == YES ? @right : @left
    end

    def insert question, final_answer
      question.parent.replace(question, self) if question.parent
      final_answer == YES ? self.right = question : self.left = question
    end

    def replace candidate, replacement
      if right == candidate
        self.right = replacement
      elsif left == candidate
        self.left = replacement
      else
        return
      end
      replacement.parent = self
    end

    def right= node
      @right = node
      node.parent = self
    end

    def left= node
      @left = node
      node.parent = self
    end

    def last?
      !(right || left)
    end

    def == other
      other.is_a?(self.class) &&
          self.value == other.value &&
          self.right == other.right &&
          self.left == other.left
    end

    def to_s
      value.to_s
    end
  end
end