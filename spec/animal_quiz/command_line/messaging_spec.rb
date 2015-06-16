require 'animal_quiz/command_line/messaging'
require 'animal_quiz/command_line/messaging_interface'

module AnimalQuiz
  module CommandLine
    describe Messaging do
      let(:messaging_interface) do

        instance_double(MessagingInterface).tap do |double|
          allow(double).to receive(:output)
          allow(double).to receive(:get_input).and_return('input')
        end
      end


      subject do
        Object.new.tap do |o|
          o.extend(described_class)
          o.messaging_interface messaging_interface
        end
      end

      describe "#ask" do
        context 'valid_inputs supplied' do
          let(:valid_input){%w(y n)}
          it 'adds them to the question text' do
            expect(messaging_interface).to receive(:get_input).and_return('y')
            subject.ask(:question, valid_input: valid_input)
            expect(messaging_interface).to have_received(:output).with("#{:question} (y or n)")
          end

          context 'invalid input supplied' do
            it 'asks for the input again' do
              expect(messaging_interface).to receive(:output).with("#{:question} (y or n)").ordered
              expect(messaging_interface).to receive(:get_input).and_return('Invalid').ordered
              expect(messaging_interface).to receive(:output).with("#{:question} (y or n)").ordered
              expect(messaging_interface).to receive(:get_input).and_return('y').ordered
              subject.ask(:question, valid_input: valid_input)
            end
          end
        end

        context 'User enters blank' do
          it 'asks for the input again' do
            expect(messaging_interface).to receive(:output).with(:question).ordered
            expect(messaging_interface).to receive(:get_input).and_return("").ordered
            expect(messaging_interface).to receive(:output).with(:question).ordered
            expect(messaging_interface).to receive(:get_input).and_return('something').ordered
            subject.ask(:question)
          end
        end
        it 'prints the question' do
          subject.ask :question
          expect(messaging_interface).to have_received(:output).with(:question)
        end

        it 'returns the response to the question' do
          expect(messaging_interface).to receive(:get_input).and_return(:answer)
          expect(subject.ask(:question)).to eq(:answer)
        end

      end
    end
  end
end