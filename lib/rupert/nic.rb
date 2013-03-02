require 'libvirt'

module Rupert
  class Nic

    attribute :type
    attribute :model

    def initialize options = {}
      @connection = Rupert.active_connection
    end

    def default_type 
      @type = "bridge"
    end

    def default_model
      @model = "virtio"
    end

  end
end
