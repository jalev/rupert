require 'libvirt'

module Rupert
  class Connect
    
    attr_reader :connection, :raw

    # During the initialization of the class, we call the Libvirt library to
    # open up a connection to the hypervisor.
    #
    def initialize uri, options = {}
      begin
        @connection = Libvirt::open(uri)
        @raw = @connection
      rescue Libvirt::ConnectionError => e
        raise Rupert::Errors::ConnectionError.new("Connection failed: #{e.to_s.split("Call to virConnectOpen failed: ")[1]}")
      end
    end

    # Returns the underlaying Libvirt connection for when we're really, really
    # lazy.
    #
    def raw
      return @raw
    end

    # Terminate an active connection.
    #
    def disconnect
      connection.close
    end

    # Return a boolean on the connection state. Returns true if closed, false
    # if open.
    #
    def closed?
      connection.closed?
    end

    # Create a new Host object after a connection. We shall use this to begin
    # creating Host-specific functions.
    #
    def host
      Rupert::Host.new
    end
  end
end
