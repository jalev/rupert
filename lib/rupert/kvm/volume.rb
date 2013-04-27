require 'libvirt'
require 'rupert/utility' #ensure that the utility class is actuall loaded

module Rupert
  class Volume 
    include Rupert::Utility

    # TODO allow the specification of alternate volume sizes
    # TODO cloning
    # TODO wiping

    # The name of the volume.
    attr_accessor :name 
    
    # The name of the pool that the volume belongs to, or should be created
    # on.
    attr_accessor :pool
    
    # The size of the volume.
    attr_accessor :size
    
    # How much of the volume should be allocated. If not specified, then a
    # sparse file is created instead.
    attr_accessor :alloc
    
    # The format of the volume. 
    attr_accessor :format 

    # The path of the volume.
    attr_accessor :path

    # Path of the template
    attr_reader :template_path

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
      @pool = options[:pool].nil? ? default_pool : @connection.host.lookup_pool(:name => options[:pool]) 
      @format = options[:format] || default_volume_format
      @alloc = options[:alloc] || default_allocation_size
      @size = options[:size] || default_capacity_size
      @template_path = options[:template_path] || default_template_path
    end

    # Passes the volume object to a method in pool which defines the actual
    # volume. We do not want to modify a volume outside of a pool object since
    # a volume is by default a subset of a pool.
    #
    def save
      pool.create_volume(self)
    end

    def destroy
      return true if new?
      find_volume(name).delete
      new?
    end

    # Returns true if the volume doesn't exist
    def new?
      find_volume(name).nil?
    end

    def path
      "#{pool.path}/#{name}"
    end

    private

    def find_volume name
      #todo redo this for redone pool interfacing
      begin
        return @pool.find_volume_by_name(name)
      rescue Libvirt::RetrieveError
      end
    end

    # Fetch the first pool.
    def default_pool
      @connection.host.list_pools.first
    end

    def default_allocation_size
      "0"
    end

    def default_capacity_size
      "5"
    end

    def default_volume_format
      "raw"
    end

    def default_template_path
      "volume.xml.erb"
    end

  end
end
