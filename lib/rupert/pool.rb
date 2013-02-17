require 'libvirt'

module Rupert

  class Pool

    attr_reader :connection

    # Notes: Storage Pools are pieces of storage that can be accessed via
    # external machines
    #

    # Create pool
    # List available pools

    def initialize options = {} 

      @connection = Virt.active_connection
      @pool = @connection.lookup_storage_pool_by_name(options[:name])
      @pool

    end

    # Create a storage pool 
    # we need to define an xml 
    #
    def create_pool name 
      connection.define_storage_pool_xml name   
    end

  end

end
