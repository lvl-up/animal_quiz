module AnimalQuiz
  module CommandLine
    class MessagingInterface
      attr_reader :output_device, :input_device
      def initialize output_device: $stdout, input_device: $stdin
        @output_device, @input_device = output_device, input_device
      end

      def output message
        output_device.puts message
      end

      def get_input
        input_device.gets.chomp.strip
      end
    end
  end
end