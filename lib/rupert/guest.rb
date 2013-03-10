require 'libvirt'
require 'rupert/utility' #ensure the utility class is actually loaded 

module Rupert
  
  # Guest class contains specific functions for the creation and destruction
  # of 'Guests'. The actual call to create the guests are handled by the host.
  #
  class Guest
    include Rupert::Utility

    attr_accessor :volume, :ram, :vcpu, :iso_file, :os_type, :cmdargs, :pool, :size, :guest, :name, :domain_type, :arch, :maxram
    attr_accessor :display_type, :display_port

    # The UUID of the Virtual Machine
    attr_reader :uuid

    # The xml definition dumped by libvirt
    attr_reader :xml_desc

    attr_reader :template_path

    attr_reader :id

    #:stopdoc:
    # TODO - Implementation of guest finding
    # TODO - Implementation of guest starting
    # TODO - Implementation of guest stopping
    # TODO - Implementation of guest destroying
    #
    #:startdoc:

    # A Guest (or virtual machine, depending on who you ask) can be created by
    # inputting some options.
    #
    # == Arguments
    #
    # * +:name+ - The name of the volume to be created
    #
    # === Guest Creation
    # * +:vcpu+ - The amount of VCPUs to attach to the guest. Defaults to 1.
    # * +:ram+  - The amount of RAM to attach to the guest. Defaults to 512mb.
    # * +:iso_file+  - The location of the ISO of which to install the Guest from.
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
    # === Volume Creation
    # * +:volume_format+  - The format of the volume for the guest.
    # * +:volume_capacity+  - The capacity of the volume
    # * +:volume_allocation+  - The allocation size of the volume
    #
    # == Examples
    #     
    #     Rupert::Guest.new(:name => "test", :ram => 512, 
    #               :iso  => "/isos/cent.iso",
    #               :cmdargs => "ks=http://localhost/ks.cfg")
    #
    def initialize options={}
      @connection = Rupert.connection
      @name = options[:name] || raise("Missing attribute: Name")
      find_guest_by_name
      # If we have found the guest, then we have no need to set the values,
      # otherwise...
      @vcpu ||= options[:vcpu] || default_vcpu
      @ram ||= options[:ram] || default_ram
      @os_type ||= options[:os_type] || default_os_type
      @domain_type ||= options[:domain_type] || default_domain_type
      @arch ||= options[:arch] || default_arch
      @cmdargs = options[:cmdargs]
      @pool = options[:pool] || default_pool
      @display_type ||= options[:display_type] || default_display_type
      @display_port ||= options[:display_port] || default_display_port
      @iso_file = options[:iso_file]
      
      @template_path = options[:template_path] || default_template_path
      @volume = Volume.new(options)
    end

    def save
      raise Rupert::Errors::Guest::GuestIsRunning if running?
      @guest = @connection.raw.define_domain_xml(xml_template)
      @xml_desc = @guest.xml_desc
      get_guest_info
      #return a bool to ensure we can pass any assertions
      !new?
    end

    def running?
      return false if new?
      @guest.active?
    end

    def start
      raise Rupert::Errors::GuestNotCreated if new?
      @guest.create if !running?
      running?
    end

    def restart
      raise Rupert::Errors::GuestNotStarted if !running? 
      @guest.reboot if running?
      running?
    end

    def suspend
      raise Rupert::Errors::GuestNotStarted if !running?
      @guest.suspend
      !running?
    end

    def state
      @guest.state
    end

    def resume
      raise Rupert::Errors::GuestNotCreated if new?
      raise Rupert::Errors::GuestAlreadyRunning if running?
      @guest.resume
      running?
    end

    def shutdown
      raise Rupert::Errors::GuestNotStarted if !running?
      @guest.shutdown
      !running?
    end

    def force_shutdown
      raise Rupert::Errors::GuestNotStarted if !running?
      @guest.destroy if running?
      !running?
    end

    def destroy
      return true if new?
      force_shutdown if running?
      @guest.undefine
      !new?
    end

    # A bool to ensure that we know if the guest has been defined or not
    def new?
      @guest.nil?
    end

    private

    def find_guest_by_name
      begin
        @guest = @connection.raw.lookup_domain_by_name(name)
        get_guest_info
      rescue Libvirt::RetrieveError
      end
    end

    def get_guest_info
      return if new? # If the guest doesn't exist, then don't return anything.
      @xml_desc = @guest.xml_desc
      @uuid = value_from_xml("domain/uuid")
      @vcpu = value_from_xml("domain/vcpu")
      @arch = value_from_xml("domain/os/type", "arch")
      @ram = value_from_xml("domain/currentMemory")
      @display_type = value_from_xml("domain/devices/graphics", "type")
      @display_port = value_from_xml("domain/devices/graphics", "port")
    end

    def default_pool
      "default"
    end

    # Default amount of RAM attached to the guest. 
    #
    def default_ram
      512 
    end

    # Default amount of VCPUs attached to the guest.
    #
    def default_vcpu
      1
    end

    # Default architecture of the guest. x64 is the default due to client
    # specification.
    #
    def default_arch
      "x86_64"
    end

    # Default type specifies the type of guest. "hvm" specifies that the VM will
    # run on bare-metal. 
    #
    def default_os_type
      "hvm"
    end

    # The default type of 'domain' created. In reality we're specifying the
    # hypervisor type. Defaults to KVM. 
    #
    def default_domain_type
      "kvm"
    end

    # The default graphical provider. Defaults to VNC.
    def default_display_type
      "vnc"
    end

    def default_display_port
      "-1"
    end

    # The default path of the template which we use to create guests. 
    def default_template_path
      "guest.xml.erb"
    end

  end
end
