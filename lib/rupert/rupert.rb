require 'libvirt'

module Rupert
  class Connect

    #TODO - Connect to the hypervisor
    def initialize( uri )
      @connection = Libvirt::open( uri )
    end

    def disconnect_from_hypervisor
      @connection.close
    end

    def closed?
      @connection.closed?
    end

  end
end
