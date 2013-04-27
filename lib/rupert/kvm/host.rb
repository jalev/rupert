require 'libvirt'

module Rupert::KVM
  # TODO Host status tools
  # TODO Host creation
  # TODO Host - Transient Domain?

  class Host < Rupert::Host

    def create_guest options
      Rupert::KVM::Guest.new options
    end

end
