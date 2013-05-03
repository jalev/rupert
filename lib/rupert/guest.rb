require 'libvirt'
require 'rupert/utility' #ensure the utility class is actually loaded 
require 'rupert/config'

module Rupert
  
  # Guest class contains specific functions for the creation and destruction
  # of 'Guests'. The actual call to create the guests are handled by the host.
  #
  class Guest
    include Rupert::Config
    include Rupert::NetInstall
    include Rupert::Utility

    attr_accessor :disk, :ram, :cpu, :iso, :os_type, :cmdargs, :pool, :size, :guest, :name, :domain_type, :arch, :maxram
    attr_accessor :display_type, :display_port, :remote, :kickstart_file, :root_pass, :kickstart, :os
    attr_accessor :remote, :kernel, :initrd, :kickstart_template, :config_file, :config_dir

    # The UUID of the Virtual Machine
    attr_reader :uuid

    # The xml definition dumped by libvirt
    attr_reader :xml_desc

    attr_reader :template_path

    attr_reader :id

    attr_reader :current_ram

    #:stopdoc:
    # TODO puppet modules
    #
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
      @connection = Rupert.connection
      @name = options[:name] || raise(Rupert::Errors::MissingRequiredAttribute)

      find_guest_by_name 
      # If we have found the guest, then we have no need to set the values,
      # otherwise...
      #
      # Required values
      @cpu          ||= options[:cpu] || default_vcpu
      @ram          ||= options[:ram] || default_ram
      @os_type      ||= options[:os_type] || default_os_type
      @os           =   options[:os]
      @hostname     ||= options[:hostname] 
      @domain_type  ||= options[:domain_type] || default_domain_type
      @arch         ||= options[:arch] || default_arch
      @pool         =   options[:pool] || default_pool
      @display_type ||= options[:display_type] || default_display_type
      @display_port ||= options[:display_port] || default_display_port

      # Optional Values
      #
      @cmdargs      ||=   options[:cmdargs]
      @iso          ||=   options[:iso]
      @kickstart    ||=   options[:kickstart] 
      @remote       ||=   options[:remote]
      @template_path =  options[:template_path] || default_template_path
      @root_pass    =   options[:root_pass]
      
      # We want to be able to pass seperate volume commands at object
      # instanciation. 
      #
      if options[:disk_name] || @disk_name
        volname = {:name => options[:disk_name]}
      else
        volname = {:name => @name} 
      end
      volops = {:size => options[:disk_size], :alloc => options[:disk_alloc],
                :pool =>  options[:pool], :format => options[:disk_format]}

      volops = volops.merge(volname)
      @disk = Disk.new(volops)
    end

    # Saves the virtual machine. The same method is used to alter the virtual
    # machine.
    #
    def save
      raise Rupert::Errors::MissingRequiredAttribute if @name.nil?

      # Linux needs a whopping total of 4mb of ram to run. 
      #
      raise Rupert::Errors::GuestNeedsRam if @ram < 4 

      # If we have a remote url, we need to begin fetching things
      if @remote
        @kernel = fetch_kernel
        @initrd = fetch_initrd
      end

      begin
        @guest = @connection.raw.define_domain_xml(xml_template)
      rescue Libvirt::DefinitionError 
        raise Rupert::Errors::DefinitionError
      end

      get_guest_info
      @xml_desc = @guest.xml_desc
      #return a bool to ensure we can pass any assertions
      !new?
    end


    # Is the guest running?
    #
    def running?
      return false if new? # We need to return false if guest hasn't been defined
      @guest.active?
    end

    def updated?
      return @guest.updated?
    end

    # Starts a guest
    #
    def start
      raise Rupert::Errors::GuestNotCreated if new?
      raise Rupert::Errors::GuestAlreadyRunning if running?
      @guest.create
      @on_poweroff = "destroy"
      @on_restart = "reboot"
      @on_crash = "reboot"
      # Post-installation requirement
      @connection.raw.define_domain_xml(xml_template)
      running?
    end

    # Restarts a guest
    #
    def restart
      raise Rupert::Errors::GuestNotCreated if new?
      raise Rupert::Errors::GuestNotStarted if !running? 
      @guest.reboot if running?
      running?
    end

    # Suspends a guest
    #
    def suspend
      raise Rupert::Errors::GuestNotCreated if new?
      raise Rupert::Errors::GuestNotStarted if !running?
      @guest.suspend
      !running?
    end

    # Retrieves an array of states, and returns a string value
    # of the guest state
    #
    def state
      raise Rupert::Errors::GuestNotCreated if new?
      case @guest.state[0]
      when 0
        return "No State"
      when 1
        return "Running"
      when 2
        return "Blocked"
      when 3
        return "Paused"
      when 4
        return "Shutting Down"
      when 5
        return "Shut Off"
      when 6
        return "Crashed"
      when 7
        return "Suspended by VM Power Management"
      end
    end

    # Resumes a guest from suspension.
    #
    def resume
      raise Rupert::Errors::GuestNotCreated if new?
      raise Rupert::Errors::GuestAlreadyRunning if running?
      raise Rupert::Errors::GuestNotSuspended if @guest.state == "Paused"
      @guest.resume
      running?
    end

    # Shuts a guest down
    #
    def shutdown
      raise Rupert::Errors::GuestNotCreated if new?
      raise Rupert::Errors::GuestNotStarted if !running?
      @guest.shutdown
      !running?
    end

    # Shuts a guest down harder. Equivalent functionality is powering off the
    # guest by pressing the power-off button.
    #
    def force_shutdown
      raise Rupert::Errors::GuestNotCreated if new?
      raise Rupert::Errors::GuestNotStarted if !running?
      @guest.destroy if running?
      !running?
    end

    # Undefines a guest
    #
    def delete
      return true if new?
      force_shutdown if running?
      @guest.undefine
      !new?
    end

    # A bool to ensure that we know if the guest has been defined or not
    #
    def new?
      @guest.nil?
    end

    # Dumps the XML template used to provision VMs. Used for debugging.
    #
    def dump_template_xml
      xml_template
    end

    # Dumps the XML retrieved from libvirt. Used for debugging.
    def dump_xml
      @guest.xml_desc
    end

    def get_vnc_port
      raise Rupert::Errors::GuestNotStarted if !running?
      find_guest_by_name
      @display_port
    end

    # Because the guest will automatically destroy itself after booting, 
    # we must make a process that checks whether the install has completed
    # so that we can boot the machine again.
    #
    def wait_for_install_completion(wait_time=0)
      # TODO
    end

    private

    # Fetches the InitRD file for remote installations
    def fetch_initrd
      get_config_file
      download_file(@remote, "images/pxeboot/initrd.img", "#{@config_dir}/os/#{@os}/initrd.img") 
    end

    # Fetches the Kernel file for remote installations
    def fetch_kernel
      get_config_file
      download_file(@remote, "images/pxeboot/vmlinuz", "#{@config_dir}/os/#{@os}/vmlinux") 
    end

    # Find guest info by the guest's ID
    #
    def find_info_by_id
      begin
        @guest = @connection.raw.lookup_domain_by_id(id)
        get_guest_info
      rescue Libvirt::RetrieveError
      end
    end

    # Find guest info by the guest's ID
    #
    def find_info_by_uuid
      begin
        @guest = @connection.raw.lookup_domain_by_id(uuid)
        get_guest_info
      rescue Libvirt::RetrieveError
      end
    end

    # Find the guest info by the guest's name
    #
    def find_guest_by_name
      begin
        @guest = @connection.raw.lookup_domain_by_name(name)
        get_guest_info
      rescue Libvirt::RetrieveError
      end
    end

    # Return information about the virtual machine from an XML dump provided
    # by libvirt
    #
    def get_guest_info
      return if new? # If the guest doesn't exist, then don't return anything.
      @xml_desc       = @guest.xml_desc
      @on_restart     = value_from_xml("domain/on_reboot")
      @on_poweroff    = value_from_xml("domain/on_poweroff")
      @on_crash       = value_from_xml("domain/on_crash")
      @uuid           = value_from_xml("domain/uuid")
      @cpu            = value_from_xml("domain/vcpu")
      @arch           = value_from_xml("domain/os/type", "arch")
      @ram            = convert_from_kb_to_mb(value_from_xml("domain/currentMemory"))
      @display_type   = value_from_xml("domain/devices/graphics", "type")
      @display_port   = value_from_xml("domain/devices/graphics", "port")
      @kerneltmp      = value_from_xml("domain/os/kernel") if @kerneltmp
      @initrdtmp      = value_from_xml("domain/os/initrd") if @initrdtmp
      @cmdargs        = value_from_xml("domain/os/cmdline") if @cmdargs || @kickstart || @remote
      @id             = @guest.id if running? # The guest will not return an ID unless running
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
    #
    def default_display_type
      "vnc"
    end

    # Default port. -1 indicates that the system should provide the port.
    #
    def default_display_port
      "-1"
    end

    # The default path of the template which we use to create guests. 
    #
    def default_template_path
      "guest.xml.erb"
    end

  end
end
