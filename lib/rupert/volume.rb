require 'libvirt'

module Rupert
  class Volume
    
    attr_reader :name, :pool, :size, :allocation

    # TODO 

    def initialize options = {}
      @connection = Rupert.active_connection 
      @name = options[:name]
      @pool = options[:pool]
      @size = options[:size]
      @allocated_size = options[:allocation]
    end

    def create_volume 
      pool.create_volume_xml #xml goes here
    end

    def destroy_volume    
    end

    def volume_exist?
      
    end

    def find_volume
      @volume = pool.lookup_volume_by_name name
    end

  end
end
