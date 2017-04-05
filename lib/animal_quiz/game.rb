$LOAD_PATH.unshift(__dir__)
require 'messaging'
require 'command_line/messaging_interface'
require 'question_tree_node'

module AnimalQuiz

  class Game

    WINNING_MSG = "I win. Pretty smart, aren't I?"
    DISTINGUISH_MSG = 'Give me a incorrect_guess to distinguish a %s from an %s.'
    HOW_TO_DISTINGUISH_MSG = 'For a %s, what is the answer to your question?.'
    PLAY_AGAIN_MSG = "Play again? (y or n)"
    LOSING_MSG = "ok you win. Help me learn from my mistake before you go...\nWhat animal were you thinking of?"
    THINK_OF_ANIMAL_MSG = "Think of an animal..."
    YES_OR_NO = %W(#{YES} #{NO})

    attr_reader :default_question
    include Messaging

    def initialize(messaging_interface=CommandLine::MessagingInterface.new, default_question = QuestionTreeNode.new('elephant'))
      messaging_interface(messaging_interface)
      self.default_question = default_question
    end

    def start
      loop do
        say THINK_OF_ANIMAL_MSG
        play default_question
        break if ask(PLAY_AGAIN_MSG) == NO
      end
    end

    def play question
      if question.last?
        answer = ask "Is it a #{question}?", valid_input: YES_OR_NO
        answer == YES ? say(WINNING_MSG) : learn_new_animal(question)
      else
        answer = ask question.to_s
        play(question.next(answer))
      end
    end

    private
    def learn_new_animal(incorrect_guess)
      new_animal = QuestionTreeNode.new(ask LOSING_MSG)

      distinguishing_question_text = ask(DISTINGUISH_MSG % [new_animal, incorrect_guess])

      distinguishing_question = QuestionTreeNode.new(distinguishing_question_text).tap do |q|
        answer_to_question = ask(HOW_TO_DISTINGUISH_MSG % new_animal.to_s, valid_input: YES_OR_NO)
        q.insert(new_animal, answer_to_question)
        q.insert(incorrect_guess, opposite(answer_to_question))
      end

      self.default_question = distinguishing_question if first_time_game_played?(incorrect_guess)
    end


    def first_time_game_played?(incorrect_guess)
      incorrect_guess == default_question
    end

    def opposite answer
      answer == YES ? NO : YES
    end

    def default_question= default_question
      @default_question = default_question
    end

  end
end