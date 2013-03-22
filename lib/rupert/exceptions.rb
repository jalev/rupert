module Rupert
  module Errors

    class AttributeNotExist < AttributeError; end

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

    class NotFound < StandardError
      def message
        "The specified object could not be found"
      end
    end

  end
end
