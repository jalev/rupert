require 'libvirt'

module Rupert
  # TODO Host status tools
  # TODO Host creation
  # TODO Host - Transient Domain?

  class Host < Rupert::Connect

    attr_reader :connection

    def initialize
      # We need to get the active connection. We do this by fetching the
      # Connect Class's 'connection' variable, which is available to us
      # through the getter 'attr_reader'
      #
      @connection = Rupert.active_connection.connection
    end 

    # Returns the name of the hypervisor
    #
    def name
      connection.hostname
    end

    # Lists all defined guests on our host.
    #
    def list_guests
      connection.list_domains
    end

    # Lists all inactive guests on our host.
    #
    def list_inactive_guests
      connection.list_defined_domains
    end

    # Lists all available network interfaces on our host.
    #
    def list_interfaces
      connection.list_interfaces
    end

    # Lists all inactive network interfaces on our host.
    #
    def list_inactive_interfaces
      connection.list_defined_interfaces
    end

    # Lists all available storage-pools on the host.
    #
    def list_pools
      connection.list_storage_pools
    end

    # Lists all inactive storage-pools on the host.
    #
    def list_inactive_pools
      connection.list_defined_storage_pools
    end 

    def list_networks
      connection.list_networks
    end

  end

end
