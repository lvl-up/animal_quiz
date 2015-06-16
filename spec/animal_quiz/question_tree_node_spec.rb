require 'animal_quiz/question_tree_node'

module AnimalQuiz
  describe QuestionTreeNode do
    let(:dinosaur_question) { described_class.new('Dinosaur') }
    let(:rabbit_question) { described_class.new('Rabbit') }
    subject do
      described_class.new('Is it extinct?').tap do |q|
        q.right = dinosaur_question
        q.left = rabbit_question
      end
    end

    describe '#replace' do
      let(:old) { described_class.new('old question') }
      let(:new) { described_class.new('new question') }
      context 'candidate is set on yes leaf' do
        it 'replaces the old entry and set the parent' do
          subject.right = old
          subject.replace(old, new)

          expect(subject.right).to be(new)

          expect(new.parent).to be(subject)
        end
      end

      context 'candidate is set on no leaf' do
        it 'replaces the old entry and set the parent' do
          subject.left = old
          subject.replace(old, new)

          expect(subject.left).to be(new)

          expect(new.parent).to be(subject)
        end
      end
    end


    describe '#insert' do
      let(:new_question) { described_class.new('question?') }
      it 'sets the parent to be the new question' do
        new_question.insert(subject, YES)
        expect(subject.parent).to eq(new_question)
      end

      context "anwser to question is #{NO}" do
        it 'sets the no leaf' do
          new_question.insert(subject, NO)
          expect(new_question.left).to eq(subject)
          expect(new_question.right).to be_nil
        end
      end

      context "anwser to question is #{YES}" do
        it 'sets the yes leaf' do
          new_question.insert(subject, YES)
          expect(new_question.right).to eq(subject)
          expect(new_question.left).to be_nil
        end
      end
    end

    describe '#next' do
      context 'y is passed' do
        it 'returns the yes leaf' do
          expect(subject.next('y')).to eq(dinosaur_question)
        end
      end
      context 'n is passed' do
        it 'returns the no leaf' do
          expect(subject.next('n')).to eq(rabbit_question)
        end
      end
    end

    describe "#to_s" do
      it 'returns the value' do
        expect(subject.to_s).to eq(subject.value.to_s)
      end
    end
  end
end