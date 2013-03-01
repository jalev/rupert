require 'libvirt'

module Rupert
  # TODO Host connection tools
  # TODO VM Creation
  # TODO Network Interfaces
  # TODO Storage Pool Creation

  # TODO Howto read ruby templates
  # TODO Howto write XML docs
  #
  
  # Guest class contains specific functions for the creation and destruction
  # of 'Guests'. The actual call to create the guests are handled by the host.
  #
  class Guest
    
    def initialize options={}
      @connection = Rupert.active_connection
      @volume = Volume.new options
      @ram = options[:ram] || default_ram
      @cpu = options[:cpu] || default_cpu
      @arch = options[:arch] || default_arch
      @name = options[:name] || raise("You must specify a name!")
      @template_path = options[:template_path] || default_template_path
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
