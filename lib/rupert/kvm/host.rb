require 'libvirt'

module Rupert::KVM
  # TODO Host status tools
  # TODO Host creation
  # TODO Host - Transient Domain?

  class Host < Rupert::Host

    def create_guest options
      Rupert::KVM::Guest.new options
    end

    def create_pool options
      Rupert::KVM::Pool.new options
    end

    def create_disk options
      Rupert::KVM::Disk.new options
    end

    def create_nic options
      Rupert::KVM::Nic.new options
    end

  end

end
