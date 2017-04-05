module AnimalQuiz
    module Messaging
      def messaging_interface interface=nil
        return @messaging_interface unless interface
        @messaging_interface = interface
      end

      def say message
        messaging_interface.output(message)
      end

      def ask question, valid_input: []
        if valid_input.empty?
          say question
        else
          requirements = "(#{valid_input.join(' or ')})"
          say "#{question} #{requirements}"
        end

        answer = messaging_interface.get_input

        ask question, valid_input: valid_input if answer.empty?

        return answer if valid_input.empty? || valid_input.include?(answer)
        ask question, valid_input: valid_input
      end
    end
end