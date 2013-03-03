require 'libvirt'
require 'rupert/utility' #ensure that the utility class is actuall loaded

module Rupert
  class Volume 
    include Rupert::Utility

    # TODO allow the specification of alternate volume sizes
    # TODO cloning
    # TODO wiping

    attr_accessor :name, :pool, :capacity, :allocation, :volume_path, :format, :path

    # A volume can be created by passing in some options. A volume must be
    # attached to a Pool before creation.
    #
    # * +:name+ - The name of the volume to be created
    # * +:pool+ - The name of the pool that this volume will be created on.
    # This defaults to 'default'.
    # * +:capacity+  - Capacity of the volume. Defaults to 5GB.
    # * +:allocation+ - The amount of space allocated. Defaults to 0. This
    # creates a 'sparse disk' by default.
    #
    # == Examples
    #     # Create a new volume called 'test_volume' with a size of 20gb
    #     Rupert::Volume.new(:name => "test_volume", :size => "20")
    #
    def initialize options = {}
      @connection = Rupert.connection
      @name = options[:name] || raise("Volume needs a name")
      @pool = options[:pool] || default_pool_name
      @format = options[:format] || default_volume_format
      @allocation = options[:allocation] || default_allocation_size
      @capacity = options[:capacity] || default_capacity_size
    end

    # Saves the volune. We also want the path of the newly created volume.
    def save
      self.path = create_volume(xml_template).path
    end

    def destroy
      find_volume(name).delete
      new?
    end

    def new?
      find_volume(name).nil?
    end

    private

    def create_volume xml
      storage_pool.create_vol_xml(xml)
    end

    # A raw connection to a pool. Inherits the name of the pool from
    # initialization. 
    #
    def storage_pool 
      @connection.raw.lookup_storage_pool_by_name(pool)
    end

    def find_volume name
      begin
        return storage_pool.lookup_volume_by_name(name)
      rescue Libvirt::RetrieveError
      end
    end

    # Default pool name always defaults to 'default'
    def default_pool_name 
      "default"
    end

    def default_allocation_size
      0 
    end

    def default_capacity_size
      5
    end

    def default_volume_format
      "raw"
    end

  end
end
