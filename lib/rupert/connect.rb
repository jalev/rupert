require 'libvirt'

module Rupert
  class Connect
    
    attr_reader :connection

    # During the initialization of the class, we call the Libvirt library to
    # open up a connection to the hypervisor.
    #
    def initialize( uri )
      @connection = Libvirt::open( uri )
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
