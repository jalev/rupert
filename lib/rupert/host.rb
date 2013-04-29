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

    def list_number_of_active_guests
      connection.num_of_domains
    end

    def list_number_of_inactive_guests
      connection.num_of_defined_domains
    end

    def find_guest guest
      create_guest(:name => guest.is_a?(Libvirt::Domain) ? guest.name : guest)
      rescue Libvirt::RetrieveError
    end

    def find_interface interface
      create_nic(:name => interface.is_a?(Libvirt::Interface) ? interface.name : interface)
      rescue Libvirt::RetrieveError
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

    def list_disks options
      temp = create_pool(:name => options[:pool])
      temp.list_disks.map do | disk |
        find_disk(disk)
      end
    end

    def find_disk disk
      create_disk(:name => disk.is_a?(Libvirt::StorageVol) ? disk.name : disk)
      rescue Libvirt::RetrieveError
    end

    def find_pool pool
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

    def list_number_of_pools
      connection.num_of_storage_pools
    end

    def list_number_of_inactive_pools
      connection.num_of_defined_storage_pools
    end

    # Lists all inactive storage-pools on the host.
    #
    def list_inactive_pools
      connection.list_defined_storage_pools
    end 

    def list_networks
      connection.list_networks
    end

    def list_inactive_networks
      connection.list_defined_networks
    end

    def list_number_of_networks
      connection.num_of_networks
    end

    def list_number_of_inactive_networks
      connection.num_of_defined_networks
    end

    def create_disk options
      Rupert::Disk.new(options)
    end

    def create_pool options
      Rupert::Pool.new(options)
    end
  
    def create_guest options
      Rupert::Guest.new(options)
    end

    def create_nic options
      Rupert::Nic.new(options)
    end

    private

    # Will return Guest objects which can be formatted for later use.
    #
    def find_guests_by_id id
      Array(id).map do | guestId |
        name = @connection.lookup_domain_by_id(guestId).name
        create_guest({:name => name})
      end
    end

    # Will return Guest objects which can be formatted for later use.
    #
    def find_guests_by_name name
      Array(name).map do | guestName |
        create_guest({:name => guestName})
      end
    end

    def lookup_pool name
      begin
        create_pool(name)
      rescue Libvirt::RetrieveError
      end
    end

  end

end
