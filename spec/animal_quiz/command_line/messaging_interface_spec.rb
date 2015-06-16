require 'animal_quiz/command_line/messaging_interface'

shared_context :command_line do
  require 'stringio'

  def set_stdin(string)
    $stdin = StringIO.new(string)
  end

  after do
    $stdin = STDIN
  end
end

module AnimalQuiz
  module CommandLine
    describe MessagingInterface do
      include_context :command_line
      describe '#initialize' do
        it 'defaults the output_device' do
          expect(subject.output_device).to eq($stdout)
        end

        it 'defaults the input_device' do
          expect(subject.input_device).to eq($stdin)
        end
      end

      describe '#get_input' do
        it 'returns input from stdin' do
          set_stdin "user_input\n"
          expect(subject.get_input).to eq('user_input')
        end
      end

      describe '#output' do
        it 'outputs the given string' do
          expect($stdout).to receive(:puts).with(:message)
          subject.output(:message)
        end
      end
    end
  end
end

require 'stringio'

def capture_name
  $stdin.gets.chomp
end

describe 'capture_name' do
  before do
    $stdin = StringIO.new("James T. Kirk\n")
  end

  after do
    $stdin = STDIN
  end

  it "should be 'James T. Kirk'" do
    expect(capture_name).to be == 'James T. Kirk'
  end
end