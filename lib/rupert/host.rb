require 'libvirt'

module Rupert
  # TODO Host status tools
  # TODO Host creation
  # TODO Host - Transient Domain?

  class Host < Rupert::Connect

    attr_reader :connection

    def initialize
      @connection = Rupert.connection.raw
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
      connection.list_storage_pools.map do | pool |
        create_pool({:name => pool})
      end
    end

    # Lists all inactive storage-pools on the host.
    #
    def list_inactive_pools
      connection.list_defined_storage_pools
    end 

    def list_networks
      connection.list_networks
    end

    def lookup_pool name
      begin
        create_pool(name)
      rescue Libvirt::RetrieveError
      end
    end

    def create_pool options
      Rupert::Pool.new(options)
    end

  end

end
