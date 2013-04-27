require 'libvirt'

module Rupert

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

    # Finds the information about a guest via its ID
    #
    def find_guest_by_id

    end

    # Lists all defined guests on our host.
    #
    def list_guests
      ids = connection.list_domains
      find_guests_by_id(ids)
    end

    # Lists all inactive guests on our host.
    #
    def list_inactive_guests
      names = connection.list_defined_domains
      find_guests_by_name(names)
    end

    def list_interface interface
      connection.lookup_interface_by_name(interface)
    end

    # Lists all available network interfaces on our host.
    #
    def list_interfaces
      connection.list_interfaces.sort
    end

    # Lists all inactive network interfaces on our host.
    #
    def list_inactive_interfaces
      connection.list_defined_interfaces
    end

    def list_pool name
      create_pool(:name => pool.is_a?(Libvirt::StoragePool) ? pool.name : pool)
      rescue Libvirt::RetrieveError
    end

    # Lists all available storage-pools on the host.
    #
    def list_pools
      connection.list_storage_pools.map do | pool |
        lookup_pool({:name => pool})
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

    private

    # Will return Guest objects which can be formatted for later use.
    #
    def find_guests_by_id id
      Array(id).map do | guestId |
        name = @connection.lookup_domain_by_id(guestId).name
        guest({:name => name})
      end
    end

    # Will return Guest objects which can be formatted for later use.
    #
    def find_guests_by_name name
      Array(name).map do | guestName |
        guest({:name => guestName})
      end
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
  
    def create_guest options
      Rupert::Guest.new(options)
    end

  end

end
