require 'libvirt'

module Rupert

  class Pool
    include Rupert::Utility


    attr_reader :uuid, :size, :alloc, :available, :num_of_disks

    attr_accessor :autostart

    # The physical connection to the libvirt daemon
    attr_reader :connection

    # The name of the pool.
    attr_reader :name

    # The path of the pool.
    attr_reader :path

    # The physical libvirt pool object
    attr_reader :pool

    # The XML dump of a given pool given to us by the libvirt daemon.
    attr_reader :xml_desc

    # The location of the xml template
    attr_reader :template_path

    # A storage space for providing CRUD methods relating to volumes and
    # physical storage.
    #
    # == Attributes ==
    #
    # === Required ===
    # * +:name+ - The name of the pool. This is *required*
    #
    # === Optional ===
    # * +:path+ - The path of the pool. Used for creating storage pools.
    #
    def initialize options = {} 

      @connection = Rupert.connection.raw
      # Performs a boolean operation on the variable. If nil/false, we raise
      # an error
      @name           = options[:name] || raise("must provide a name!")
      get_pool
      @path           = options[:path]
      @autostart      = options[:autostart]
      @template_path  = options[:template_path] || default_template_path
    end

    # Create a storage pool 
    # we need to define an xml 
    #
    def save 
      raise Rupert::Errors::PoolPathError if path.nil?
      raise Rupert::Errors::PoolAlreadyExist if exist? 
      begin
        @pool = connection.define_storage_pool_xml(xml_template)
      rescue Libvirt::Error
        raise Rupert::Errors::DefinitionError
      rescue Libvirt::DefinitionError 
        raise Rupert::Errors::DefinitionError
      end
      get_pool
    end

    def start
      raise Rupert::Errors::PoolAlreadyStarted if active?
      @pool.create
      active?
    end

    def build
      raise Rupert::Errors::PoolNotCreated if new?
      raise Rupert::Errors::PoolAlreadyStarted if active?
      @pool.build
      build?
    end

    # This is different from the delete function in that it deletes the
    # underlying resources under the pool.
    #

    def delete_pool
      raise Rupert::Errors::PoolNotCreated if new?
      @pool.delete
    end

    def stop
      raise Rupert::Errors::PoolNotCreated if new?
      raise Rupert::Errors::PoolAlreadyStopped if !active?
      @pool.destroy
      !active?
    end

    def delete
      raise Rupert::Errors::PoolNotCreated if new?
      @pool.undefine
    end

    def list_disks
      @pool.list_volumes
    end

    def active?
      @pool.active?
    end

    def new?
      @pool.nil?
    end

    def create_disk disk_object
      #this needs to be prettier
      raise Rupert::Errors::PoolNotCreated if new?
      raise Rupert::Errors::DiskLargerThanPool if convert_from_gb_to_b(disk_object.size) > @pool.info.available

      begin
        @pool.create_vol_xml(disk_object.xml_template)
      # For some reason, the disks use 'Libvirt::Error' instead of
      # 'Libvirt::DefinitionError'
      rescue Libvirt::Error
        raise Rupert::Errors::DefinitionError
      end
    end

    def find_disk_by_name name
      begin
      @pool.lookup_volume_by_name(name)
      rescue Libvirt::RetrieveError
      end
    end

    # Returns true if a pool exists, false otherwise.
    #
    def exist?
      !get_pool.nil?
    end

    # Return the path of the storage pool
    def path
      value_from_xml("pool/target/path") 
    end

    # Check to see if the directory we build actually exists. 
    #
    def build?
      File.directory?(path)
    end

    private

    # Fetches a pool object by name. This will either return nothing (which
    # means we should create a new pool), or return a Libvirt pool object, and
    # dump its xml contents. 
    #
    def get_pool
      begin
        @pool = connection.lookup_storage_pool_by_name(name)
        @xml_desc = @pool.xml_desc
      rescue Libvirt::RetrieveError
      end
    end

    def get_pool_info
      return if new?
      return unless @pool = find_pool
      # These are the only values returned by pool information
      #
      @name       = @pool.name
      @autostart  = @pool.autostart?
      @uuid       = @pool.uuid
      @state      = @pool.info.state
      @size       = @pool.info.capacity
      @alloc      = @pool.info.allocation
      @available  = @pool.info.available
      @num_of_disk = @pool.num_of_volumes
    end

    def default_template_path
      "pool.xml.erb"
    end

  end

end
