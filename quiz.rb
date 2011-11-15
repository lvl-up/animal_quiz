$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
require 'question'

YES = 'y'
NO = 'n'



def ask question
  case question
    when Question
      answer = ask "#{question} (y or n)"
      question.yes || question.no ? [answer, question.answer(answer)] : [answer, question]
    else
      puts question
      gets.chomp
  end

end

def get_question(actual_animal, suggested_animal)
  new_question = Question.new(ask("Give me a question to distinguish a #{actual_animal} from an #{suggested_animal}."))
  answer = ask("For a #{actual_animal}, what is the answer to your question? (y or n).")

  animal_question = Question.new(actual_animal, new_question)

  if answer == YES
    new_question.yes = animal_question
    new_question.no = suggested_animal
  else
    new_question.no = animal_question
    new_question.yes = suggested_animal
  end

  suggested_animal.parent = new_question

  new_question
end

def play
  puts "Think of an animal..."

  if $question
    next_question, last_answer = $question, nil
    while next_question && (next_question.yes || next_question.no)
      last_answer, next_question = ask(next_question)
    end
  end

  suggested_animal = next_question || Question.new('elephant')
  last_question = suggested_animal.parent

  answer = ask "Is it a #{suggested_animal}? (y or n)"

  if answer == YES
    puts "I win. Pretty smart, aren't I?"
  else
    animal = ask "ok you win. Help me learn from my mistake before you go...\nWhat animal were you thinking of?"
    new_question = get_question(animal, suggested_animal)
    
    $question ? last_question.insert(new_question, last_answer) : $question = new_question
  end

end


play
while ask("Play again? (y or n)") == YES
  play
end


