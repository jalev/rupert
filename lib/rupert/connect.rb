require 'libvirt'
require 'rupert/utility'

module Rupert
  class Connect
    include Rupert::Utility
    
    attr_reader :connection, :raw, :type, :xml_desc

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
      raise Rupert::Errors::NoHostToConnect if uri.nil?
      begin
        @connection = Libvirt::open(uri)
        @raw = @connection
        @type = capabilities
      rescue Libvirt::ConnectionError => e
        raise Rupert::Errors::ConnectionError.new("Connection failed: #{e.to_s.split("Call to virConnectOpen failed: ")[1]}")
      end
    end

    # Returns the underlaying Libvirt connection for when we're really, really
    # lazy.
    #
    def raw
      raise Rupert::Errors::NoConnectionError if closed?
      return @raw
    end

    def capabilities
      raise Rupert::Errors::NoConnectionError if closed?
      @xml_desc = connection.capabilities
      values_from_xml('//capabilities/guest/arch/domain/@type')
    end

    # Terminate an active connection.
    #
    def disconnect
      raise Rupert::Errors::NoConnectionError if closed?
      connection.close
      closed?
    end

    # Return a boolean on the connection state. Returns true if closed, false
    # if open.
    #
    def closed?
      raise Rupert::Errors::NoConnectionError if @connection.nil?
      connection.closed?
    end

    # Create a new Host object after a connection. We shall use this to begin
    # creating Host-specific functions.
    #
    def host
      if type.include?("kvm")
        Rupert::KVM::Host.new
      else
        raise Rupert::Errors::NoHypervisor
      end
    end
  end
end
