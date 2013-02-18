require 'libvirt'

module Rupert

  class Pool

    attr_reader :connection, :name, :path

    # Notes: Storage Pools are pieces of storage that can be accessed via
    # external machines
    #

    # Create pool
    # List available pools

    def initialize options = {} 

      @connection = Virt.active_connection
      @pool = @connection.lookup_storage_pool_by_name(options[:name])
      @path = options[:path]
      # Trinary operation: If true, we use the default size, else we use the
      # size given.
      #
      @size = options[:size].nil? ? default_size : options[:size]
      @alloc_size = options[:allocation_size].nil? ? default_alloc_size : options[:allocation_size]
    end

    # Create a storage pool 
    # we need to define an xml 
    #
    def create_pool name 
      connection.define_storage_pool_xml name   
    end

    # For the moment we will use a simple file storage system
    #
    def file_pool
      pool_type = file_storage
      ERB.new (template_loc, nil, '-').result(binding)
    end


    def default_size 
      0
    end

    def default_allocation_size
      0
    end

    # Gets the default storage pool. By default, this is always 'default' on
    # most systems.
    #
    def fetch_default_pool
      pool = connection.list_storage_pools.first
    end

    # Read a template from our current location upwards
    def template_loc
      File.read("#{File.dirname(__FILE__}/../../templates/pools/#{pool_type}")
    end

  end

end
