require 'animal_quiz/command_line/messaging_interface'

module AnimalQuiz
  module CommandLine
    describe MessagingInterface do
      describe '#initialize' do
        it 'defaults the output_device' do
          expect(subject.output_device).to eq($stdout)
        end

        it 'defaults the input_device' do
          expect(subject.input_device).to eq($stdin)
        end
      end

      describe '#get_input' do
        let(:user_input){'user_input'}
        let(:input_device){StringIO.new("#{user_input}\n")}
        subject do
          described_class.new(input_device: input_device)
        end
        it 'returns input from stdin' do
          expect(subject.get_input).to eq(user_input)
        end
      end

      describe '#output' do
        let(:message){'message'}
        let(:output_device){StringIO.new}
        subject do
          described_class.new(output_device: output_device)
        end
        it 'outputs the given string' do
          subject.output(message)
          expect(output_device.string.chomp).to eq(message)
        end
      end
    end
  end
end
