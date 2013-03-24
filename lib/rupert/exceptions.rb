module Rupert
  module Errors

    class AttributeNotExist < ArgumentError
      def message
        "A variable is missing"
      end
    end

    class AlreadyExist < StandardError; end

    class ConnectionError < StandardError
    end

    class GuestNotCreated < StandardError 
      def message
        "The guest has not been created"
      end
    end

    class GuestNotStarted < StandardError
      def message
        "The guest has not been started"
      end
    end

    class GuestAlreadyRunning < StandardError
      def message
        "The guest has already been started"
      end
    end

    class GuestIsRunning < StandardError
      def message
        "Operation cannot be completed as guest is currently running"
      end
    end

    class NicAlreadyRunning < StandardError
      def message
        "NIC is currently running"
      end
    end

    class NicNotDefined < StandardError
      def message
        "NIC has not been defined"
      end
    end

    class NicNotRunning < StandardError
      def message
        "NIC is not currently active"
      end
    end

    class NotFound < StandardError
      def message
        "The specified object could not be found"
      end
    end

  end
end
