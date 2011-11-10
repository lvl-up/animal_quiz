require 'rspec'
require 'expect'
require 'pty'


def run_animail_quiz
  PTY.spawn "ruby ../lib/animal.rb"
end

def process_finished pid
  `ps aux | grep #{pid} | grep -v grep | awk '{print $8}'`.chomp == 'Zs'
end

$expect_verbose = true

describe 'the quiz' do

#  it 'should ask you to think of an animal' do
#    stdout, stdin, pid = run_animail_quiz()
#    stdout.gets.chomp.should == 'Think of an animal'
#  end

#  it 'should ask you to enter a question when you say no' do
#    animal = "rabit"
#    stdout, stdin, pid = run_animail_quiz()
#    
#    stdout.expect(/^Think of an animal...$/)
#    stdout.expect(/^Is it an elephant\? \(y or n\)$/)
#    stdin.puts 'n'
#    stdout.expect(/^ok you win. What animal where you thinking of\?$/)
#    
#    stdin.puts animal
#    stdout.expect(/^oh a rabit!/)
#  end
#  
#  it 'Should celebrate when it gets the answer right' do
#    stdout, stdin, pid = run_animail_quiz()
#    
#    stdout.expect(/^Think of an animal...$/)
#    stdout.expect(/^Is it an elephant\? \(y or n\)$/)
#    stdin.puts "y"
#    stdout.expect(/^I win. Pretty smart, aren't I\?$/)
#  end

  it 'Keep asking questions until it guesses what animal you are thinking of' do
    animal = "rabbit"
    stdout, stdin, pid = run_animail_quiz()

    stdout.expect(/^Think of an animal...$/)
    stdout.expect(/^Is it a elephant\? \(y or n\)$/)
    stdin.puts 'n'
    stdout.expect(/^ok you win. Help me learn from my mistake before you go...$/)
    stdout.expect(/^What animal were you thinking of\?$/)
#
    stdin.puts animal
    stdout.expect(/^Give me a question to distinguish a #{animal} from an elephant.$/)
    
    stdin.puts 'Is it a small animal?'
    stdout.expect(/^For a #{animal}, what is the answer to your question\? \(y or n\).$/)
    stdin.puts 'y'
#
    stdout.expect(/^Play again\? \(y or n\)/)
    stdin.puts "y"
#
    stdout.expect(/^Think of an animal...$/)
    stdout.expect(/^Is it a small animal\? \(y or n\)$/)
    stdin.puts 'y'
    stdout.expect(/^Is it a rabbit\?$/)
    stdin.puts 'n'
#
    animal = 'Shih Tzu'
    stdout.expect(/^ok you win. Help me learn from my mistake before you go...$/)
    stdout.expect(/^What animal were you thinking of\?$/)
    stdin.puts animal
#
    stdout.expect(/^Give me a question to distinguish a #{animal} from an rabbit.$/)
    stdin.puts 'Is it a kind of dog?'
    stdout.expect(/^For a #{animal}, what is the answer to your question\? \(y or n\).$/)
    stdin.puts 'y'
#
    stdout.expect(/^Play again\? \(y or n\)/)
    stdin.puts "y"
#
    stdout.expect(/^Think of an animal...$/)
    stdout.expect(/^Is it a small animal\? \(y or n\)$/)
    stdin.puts 'y'
    stdout.expect(/^Is it a kind of dog\? \(y or n\)$/)
    stdin.puts 'y'
#
    stdout.expect(/^Is it a #{animal}\? \(y or n\)$/)
    stdin.puts 'y'
    stdout.expect(/^I win. Pretty smart, aren't I\?$/)
#
    stdout.expect(/^Play again\? \(y or n\)/)
    stdin.puts "n"
#
    process_finished(pid).should == true
  end

#  it 'should ask you if you want to quit' do
#    stdout, stdin, pid = run_animail_quiz()
#    
#    stdout.expect(/^Think of an animal...$/)
#    stdout.expect(/^Is it an elephant\? \(y or n\)$/)
#    stdin.puts "y"
#    stdout.expect(/^I win. Pretty smart, aren't I\?$/)
#    stdout.expect(/^Play again\? \(y or n\)/)
#    stdin.puts "n"
#    
#    process_finished(pid).should == true
#    
#  end
end