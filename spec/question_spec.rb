require 'rspec'


class Question

  
  attr_accessor :yes, :no
  attr_reader :suggestion, :question
  def initialize question, suggestion
    @question = question
    @sugestion = suggestion
  end
  
  def yes
    @yes || @sugestion  
  end
  
  def no
    @yes || @sugestion  
  end
end


describe Question do
  it 'should do what I want' do
    feline= Question.new('feline','cat')
    racing = Question.new('racing', 'horse')
    meow = Question.new('meow', 'cat')
    roar = Question.new('roar', 'lion')
    
    feline.no = racing
    feline.yes = meow
    meow.no = roar
    
    meow.yes.should == 'cat'
  end
end