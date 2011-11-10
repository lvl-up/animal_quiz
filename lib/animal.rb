require 'ostruct'
have_the_correct_answer = false
play_again = true


class Question

  
  attr_accessor :yes, :no
  attr_reader  :question
  def initialize question
    @question = question
  end
  
  def answer answer
    answer == YES ? @yes : @no
  end
  
  def to_s
    @question
  end
end



YES = 'y'
NO = 'n'

def ask question
  puts question
  gets.chomp
end

def ask_question question

  answer = ask "#{question} (y or n)"
  
  question.yes || question.no ? question.answer(answer) : question 

end

def play
  puts "Think of an animal..."

  if $question
    guess = $question
    while(guess.yes || guess.no)
      last_guess = guess
      guess =  ask_question(guess)  
    end
    
     
  else
    guess = 'elephant'
    
  end

  answer = ask "Is it a #{guess}? (y or n)"

  if answer == YES
    puts "I win. Pretty smart, aren't I?"
  else
    animal = ask "ok you win. Help me learn from my mistake before you go...\nWhat animal were you thinking of?"

    question = ask("Give me a question to distinguish a #{animal} from an #{guess}.")
    answer = ask "For a #{animal}, what is the answer to your question? (y or n)."

    question = Question.new(question)
    
    if answer == YES
      if guess.is_a?Question
        last_guess.yes = question
        question.no = guess
        
      end
      question.yes = Question.new(animal)
    else
      if guess.is_a?Question
        last_guess.no = question
        question.yes = guess
      end
      question.no = Question.new(animal)
    end
    
    $question = question unless $question
    


  end

end


play
while ask("Play again? (y or n)") == YES
  play
end


