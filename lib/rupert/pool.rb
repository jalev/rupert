require 'libvirt'

module Rupert

  class Pool
    include Rupert::Utility

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
      @name = options[:name] || raise("must provide a name!")
      @path = options[:path]
      get_pool
    end

    # Create a storage pool 
    # we need to define an xml 
    #
    def save 
      raise("must provide a filestore path") if path.nil?
      raise("pool with this name already exists") if pool_exist? 
      connection.define_storage_pool_xml(xml_template)
      get_pool
    end

    def start
      pool.start
    end

    def build
      pool.build
    end

    def destroy
      pool.destroy
    end

    def undefine
      pool.undefine
    end

    def create_volume volume_object
      #this needs to be prettier
      pool.create_vol_xml(volume_object.xml_template)
    end

    # Returns true if a pool exists, false otherwise.
    #
    def pool_exist?
      !get_pool.nil?
    end

    # Return the path of the storage pool
    def path
      value_from_xml("pool/target/path") 
    end

    # Fetches a pool object by name. This will either return nothing (which
    # means we should create a new pool), or return a Libvirt pool object, and
    # dump its xml contents. 
    def get_pool
      begin
        @pool = connection.lookup_storage_pool_by_name(name)
        @xml_desc = @pool.xml_desc
      rescue Libvirt::RetrieveError
      end
    end

    def default_template_path
      "pool.xml.erb"
    end

  end

end
