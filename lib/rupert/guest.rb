require 'libvirt'

module Rupert
  
  # Guest class contains specific functions for the creation and destruction
  # of 'Guests'. The actual call to create the guests are handled by the host.
  #
  class Guest
    
    # A Guest (or virtual machine, depending on who you ask) can be created by
    # inputting some options.
    #
    # == Examples
    #     
    #     Guest.new(:name => "test"):q
    #
    def initialize options={}
    end

    def default_ram
      4
    end

    def default_cpu
      1
    end

    def default_arch
      "x86_64"
    end

    def default_template_path
      "guests/kvm.xml.erb"
    end

  end
end
