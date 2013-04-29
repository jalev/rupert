require 'libvirt'

module Rupert
  class Connect
    
    attr_reader :connection, :raw, :type

    # During the initialization of the class, we call the Libvirt library to
    # open up a connection to the hypervisor.
    #
    # Since this is a connection to the libvirt driver itself, libvirt already
    # does most of the heavy work of figuring out which type of connection to
    # give to the user.
    #
    # The types of connections available are based on what credentials the
    # user calling Rupert has. These connections are;
    #   
    #   Unsecure, user session: <driver>:///session
    #   Secure, root session:   <driver>:///system
    #
    # A user session differs from a root session in that it is entirely
    # localized to a user's profile, while the latter is for the entire
    # system.
    #
    # If a user attempts to connect to the secure session without the specific
    # privileges, then Libvirt will force a standard PAM auth to gain access.
    #
    def initialize uri, options = {}
      raise Rupert::Errors::NoHostToConnect if !uri
      begin
        @connection = Libvirt::open(uri)
        @raw = @connection
        @type = "KVM"
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
      case type
      when "KVM"
        Rupert::KVM::Host.new
      end
    end
  end
end
