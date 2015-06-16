$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
require 'animal_quiz/game'

AnimalQuiz::Game.new.start