require 'pp'
YES = 'y'
NO = 'n'

class Question
  attr_accessor :yes, :no, :parent
  attr_reader  :question
  def initialize question
    @question = question
  end
  
  def answer answer
    answer == YES ? @yes : @no
  end
  
  def insert question
    
  end
  
  def to_s
    @question
  end
end

def ask question
  puts question
  gets.chomp
end

def ask_question question
  answer = ask "#{question} (y or n)"
  question.yes || question.no ? [answer, question.answer(answer)] : [answer, question] 
end

def get_question(actual_animal, final_answer, suggested_animal)
  new_question = Question.new(ask("Give me a question to distinguish a #{actual_animal} from an #{suggested_animal}."))
  
  if suggested_animal.is_a?(Question)
    
    if @parent
      final_answer == YES ? @parent.yes = new_question : @parent.no = new_question
      new_question.parent = @parent
    end
  end
  
  @parent = new_question
   
  answer = ask("For a #{actual_animal}, what is the answer to your question? (y or n).")

  animal_question = Question.new(actual_animal)
  animal_question.parent = new_question
  
  answer == YES ? new_question.yes = animal_question : new_question.no = animal_question
  answer == YES ? new_question.no = suggested_animal : new_question.yes = suggested_animal
  
  suggested_animal.parent = new_question
  
  
  new_question
end

def play                              
  puts "Think of an animal..."

  if $question
    next_question = $question
    last_answer = nil
    while(next_question.yes || next_question.no)
      last_answer, next_question = ask_question(next_question)
      break unless next_question
    end
  end
  
  suggested_animal = next_question || Question.new('elephant')

  answer = ask "Is it a #{suggested_animal}? (y or n)"

  if answer == YES
    puts "I win. Pretty smart, aren't I?"
  else
    animal = ask "ok you win. Help me learn from my mistake before you go...\nWhat animal were you thinking of?"
    new_question = get_question(animal, last_answer, suggested_animal)
    next_question.insert(new_question) if next_question
    $question = new_question unless $question
  end

end


play
while ask("Play again? (y or n)") == YES
  play
end


