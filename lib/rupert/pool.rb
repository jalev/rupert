require 'libvirt'

module Rupert

  class Pool
    include Rupert::Utility
    attr_reader :connection, :name, :path, :pool_path_loc, :template_path, :pool

    # Notes: Storage Pools are pieces of storage that can be accessed via
    # external machines
    #

    # Create pool
    # List available pools

    def initialize options = {} 

      @connection = Rupert.active_connection.connection
      # Performs a boolean operation on the variable. If nil/false, we raise
      # an error
      @name = options[:name] || raise("must provide a name!")
      @path = options[:path]
      @template_path = options[:type] || default_template_type
    end

    # Create a storage pool 
    # we need to define an xml 
    #
    def save 
      raise("must provide a filestore path") if path.nil?
      raise("pool with this name already exists") if pool_exist? 
      connection.define_storage_pool_xml(xml_template)
      fetch_pool
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

    def default_template_type
      "pools/file_storage.xml.erb"
    end

    # Returns true if a pool exists, false otherwise.
    #
    def pool_exist?
      !fetch_pool.nil?
    end

    def fetch_pool
      begin
       connection.lookup_storage_pool_by_name(name)
      rescue Libvirt::RetrieveError
        nil
      end
    end

  end

end
