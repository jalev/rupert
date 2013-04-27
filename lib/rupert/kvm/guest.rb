require 'libvirt'
require 'rupert/utility' #ensure the utility class is actually loaded 

module Rupert::KVM
  
  # Guest class contains specific functions for the creation and destruction
  # of 'Guests'. The actual call to create the guests are handled by the host.
  #
  class Guest < Rupert::Guest
    #:startdoc:

    # A Guest (or virtual machine, depending on who you ask) can be created by
    # inputting some options.
    #
    # == Arguments
    #
    # * +:name+ - The name of the volume to be created
    #
    # === Additional arguments: Guest Creation
    # * +:vcpu+ - The amount of VCPUs to attach to the guest. Defaults to 1.
    # * +:ram+  - The amount of RAM to attach to the guest. Defaults to 512mb.
    # * +:iso+  - The location of the ISO of which to install the Guest from.
    # * +:os_type+  - The type of Guest to install. Defaults to HVM (Hardware
    # Virtual-Machine).
    # * +:domain_type+  - The type of domain we want to install. Defaults to
    # KVM. 
    # * +:arch+ - The type of architecture to install. Defaults to x64. 
    # * +:cmdargs+ - Additional arguments to pass along to the Guest at
    # creation.
    # * +:pool+ - The pool where the volume will be created, if it wasn't
    # already specified.
    # * +:display_type+ - The type of display that will be used for this
    # guest. Defaults to VNC.
    # * +:display_port+ - The port that the display will be available on.
    # Defaults to -1, which is an automatically assigned number by the Libvirt
    # daemon.
    #
    # === Additional arguments: Volume creation
    # You can specify these as additional arguments if you ensure you put them
    # into a :volume array. Please refer to Rupert::Volume for parameter
    # specification.
    #
    # == Examples
    #
    # ==== Create a guest with 512mb RAM
    #     Rupert::Guest.new(:name => "test", :ram => 512 )
    #
    # ==== Create a guest with a disk size of 10gb
    #     Rupert::Guest.new(:name => "test", :volume => {:capacity => 10} )
    #
    # ==== Alternate ways of creating guests
    #     guest = Rupert::Guest.new(:name => "test")
    #     guest.ram = 1024
    #     guest.volume.capacity = 10
    #     guest.volume.save
    #     guest.save
    #                   
    #
    def initialize options={}
      super(options)
    end

    def default_template_path
      "kvm/guest.xml.erb"
    end

  end
end
