require 'animal_quiz/game'
module AnimalQuiz

  describe Game do

    let(:messaging_interface) do
      input_stream = StringIO.new.tap do |io|
        def io.gets *args
          NO
        end
      end
      CommandLine::MessagingInterface.new(output_device: StringIO.new, input_device: input_stream)
    end

    RSpec::Matchers.define :output do |expected|
      match do |actual|
        output = actual.output_device
        output.rewind
        output.read.include?(expected)
      end
    end

    let(:default_question){subject.default_question.dup}

    subject do
      described_class.new messaging_interface
    end


    describe '#play' do

      context 'user is asked question' do
        context 'no more questions to ask' do
          it 'use the question as a guess' do
            subject.play(default_question)
            expect(messaging_interface).to output("Is it a #{default_question}?")
          end

          context "user answers #{YES}" do
            it 'gloats' do
              allow(subject).to receive(:ask).and_return(YES)
              subject.play(default_question)
              expect(messaging_interface).to output(described_class::WINNING_MSG)
            end
          end

          context "user answers n" do

            let(:new_animal){QuestionTreeNode.new('Dinosaur')}
            let(:new_question){QuestionTreeNode.new('Is it extinct?')}

            it 'asks what animal was being thought of' do
              allow(subject).to receive(:ask).and_return(NO)
              expect(subject).to receive(:ask).with(described_class::LOSING_MSG)
              subject.play(default_question)
            end

            context 'improving the knowledge base' do
              before :each do
                answer = YES
                allow(subject).to receive(:ask).and_return(NO)
                expect(subject).to receive(:ask).with(described_class::LOSING_MSG).and_return(new_animal.to_s)
                expect(subject).to receive(:ask).with(described_class::DISTINGUISH_MSG  % [new_animal.to_s, default_question.to_s] ).and_return(new_question.to_s)
                expect(subject).to receive(:ask).with(described_class::HOW_TO_DISTINGUISH_MSG  % new_animal.to_s, valid_input: described_class::YES_OR_NO).and_return(answer)
              end

              it 'asks for help being better next time' do
                subject.play(default_question)
              end

              context 'last guess was the default question' do

                it 'it replaces the default question' do
                  expected_question = new_question.tap do |q|
                    q.insert(new_animal, YES)
                    q.insert(QuestionTreeNode.new('elephant'), NO)
                  end
                  subject.play(default_question)
                  expect(subject.default_question).to eq(expected_question)
                end
              end

              context 'last guess was not the default question' do
                it 'it inserts the new question' do

                  another_question = QuestionTreeNode.new('elephant')

                  parent = QuestionTreeNode.new('massive?')
                  parent.insert(another_question, YES)

                  expected = QuestionTreeNode.new('massive?').tap do |q|
                    q.right = new_question.tap do |q2|
                      q2.insert(new_animal, YES)
                      q2.insert(default_question, NO)
                    end
                  end
                  subject.play(another_question)

                  expect(parent).to eq(expected)
                end
              end

            end

          end
        end

        context 'more questions to be asked' do
          it 'asks the question' do
            string = 'Is it extinct?'
            question = QuestionTreeNode.new(string).tap do |q|
              q.right = QuestionTreeNode.new('Dinosaur')
              q.left = QuestionTreeNode.new('Rabit')
            end

            subject.play(question)
            expect(messaging_interface).to output(question.to_s)
          end

          it 'plays using the answer to current question' do
            dinosaur_question = QuestionTreeNode.new('Dinosaur')
            question = QuestionTreeNode.new('Is it extinct?').tap do |q|
              q.right = dinosaur_question
              q.left = QuestionTreeNode.new('Rabbit')
            end

            answer = 'y'

            expect(subject).to receive(:ask).with(question.to_s).and_return(answer)
            expect(subject).to receive(:ask).with("Is it a #{dinosaur_question}?", valid_input: described_class::YES_OR_NO).and_return(answer)

            subject.play(question)
          end

        end
      end


    end

    describe '#start' do
      it 'asks you to think of an animal' do
        subject.start
        expect(messaging_interface).to output('Think of an animal...')
      end

      it 'plays the game at lease once' do
        expect(subject).to receive(:play).once
        expect(subject).to receive(:ask).with(described_class::PLAY_AGAIN_MSG).and_return(NO).ordered
        subject.start
      end

      it 'starts the game with the default question' do
        expect(subject).to receive(:play).with(subject.default_question)
        subject.start
      end

      context 'user wants to play again' do
        it 'asks them to think of another animal' do
          expect(subject).to receive(:play).with(subject.default_question).ordered
          expect(subject).to receive(:ask).with(described_class::PLAY_AGAIN_MSG).and_return(YES).ordered
          expect(subject).to receive(:play).with(subject.default_question).ordered
          expect(subject).to receive(:ask).with(described_class::PLAY_AGAIN_MSG).and_return(NO).ordered
          subject.start
        end
      end

    end

    describe "#default_question" do
      it 'returns the elephant question' do
        expect(subject.default_question).to eq(QuestionTreeNode.new('elephant'))
      end

      it 'returns the same instance each time' do
        first_call = subject.default_question
        expect(subject.default_question).to be(first_call)
      end
    end
  end
end