require 'libvirt'
require 'rupert/utility' #ensure that the utility class is actuall loaded

module Rupert
  class Volume 
    include Rupert::Utility

    # TODO allow the specification of alternate volume sizes

    attr_reader :name, :pool, :size, :allocation, :volume_path

    # A volume can be created by passing in some options. A volume must be
    # attached to a Pool before creation.
    #
    # * +:name+ - The name of the volume to be created
    # * +:pool+ - The name of the pool that this volume will be created on.
    # This defaults to 'default'.
    # * +:size+  - The size of the volume. Defaults to 10GB.
    # * +:allocation+ - The amount of space allocated
    #
    # == Examples
    #     # Create a new volume called 'test_volume' with a size of 20gb
    #     Rupert::Volume.new(:name => "test_volume", :size => "20")
    #
    def initialize options = {}
      @connection = Rupert.connection
      @name = options[:name] || raise("Volume needs a name")
      @pool = options[:pool] || default_pool_name
      @size = options[:size] || default_volume_size
      @allocated_size = options[:allocation] || size
    end

    def save
      volume_path = create_volume(xml_template).path
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

    def default_volume_size
      10
    end

  end
end
