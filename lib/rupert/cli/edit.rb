require 'thor'

module Rupert
  class CLI < Thor
    module Commands
      class Edit < Thor
        desc "vm", "Edits VM settings."
        method_option :name, 
                      :aliases  =>  "-n", 
                      :desc     =>  "The name of the thing you are going to create", 
                      :required =>  true,
                      :type     =>  :string
      
        method_option :no_vnc,
                      :desc     =>  "Do not launch VNC session",
                      :required =>  false,
                      :type     =>  :boolean
      
        method_option :virt_type,
                      :desc     =>  "Which hypervisor the machine should use",
                      :required =>  false,
                      :type     =>  :string
      
        method_option :services,
                      :desc     =>  "What should be installed on the machine?",
                      :required =>  false,
                      :type     =>  :array
      
        method_option :os,
                      :desc     =>  "Which operating system to install",
                      :required =>  false,
                      :type     =>  :string
      
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
      
        method_option :ram, 
                      :aliases      =>  "-r", 
                      :banner       =>  "RAM",
                      :default      =>  512,
                      :lazy_default =>  512,
                      :desc         =>  "The amount of ram the virtual machine should have in MB.",
                      :required     =>  false,
                      :type         =>  :numeric
      
        method_option :cpu,
                      :banner       =>  "CPU",
                      :default      =>  1,
                      :lazy_default =>  1,
                      :desc         =>  "The amount of CPUs to attach to the virtual machine.",
                      :required     =>  false,
                      :type         =>  :numeric
      
        method_option :hostname,
                      :desc         =>  "The hostname of the machine",
                      :required     =>  true,
                      :type         =>  :string
      
        method_option :kickstart,
                      :desc         =>  "kickstart the installation",
                      :required     =>  false,
                      :type         =>  :boolean
      
        method_option :root_pass,
                      :desc         =>  "root password",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :remote,
                      :desc         =>  "Information about the remote installer",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :arch,
                      :desc         =>  "The architecture you wish the virtual machine to be",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :iso,
                      :desc         =>  "The ISO file you wish to pass",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :cmdargs,
                      :desc         =>  "Additional commandline arguments that you wish to pass to the VM",
                      :required     =>  false,
                      :type         =>  :string
        
        method_option :disk_name,
                      :desc         =>  "The name you wish to give to the disk",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :disk_size,
                      :banner       =>  "GB",
                      :desc         =>  "The size of the disk, in GB",
                      :required     =>  false,
                      :type         =>  :numeric
      
        method_option :disk_type,
                      :desc         =>  "The type of disk you wish to create. Options are 'Raw' and 'QCOW2'",
                      :default      =>  "qcow2",
                      :lazy_default =>  "qcow2",
                      :required     =>  true,
                      :type         =>  :string
      
        method_option :disk_pool,
                      :desc         =>  "The pool you wish to create this disk on",
                      :default      =>  "default",
                      :lazy_default =>  "default",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :display_type,
                      :desc         =>  "The type of display",
                      :default      =>  "vnc",
                      :lazy_default =>  "vnc",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :display_port,
                      :desc         =>  "The port you wish the display to be available from",
                      :default      =>  "-1",
                      :lazy_default =>  "-1",
                      :required     =>  false,
                      :type         =>  :numeric

        def vm
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu///system"
            end
            @connection = Rupert::connect(conn).host
            vm = @connection.find_guest(options[:name])
            vm.os           ||= options[:os]
            vm.ram          ||= options[:ram]
            vm.remote       ||= options[:remote]
            vm.arch         ||= options[:arch]
            vm.iso          ||= options[:iso]
            vm.display_type ||= options[:display_type]
            vm.display_port ||= options[:display_port]
            vm.save
          rescue => e
            puts "#{e.message}"
          end
        end

        desc "pool","Creates a pool"
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
      
    
        method_option :name,
                      :aliases  =>  "-n",
                      :desc     =>  "The name of the pool", 
                      :required =>  true,
                      :type     =>  :string

        method_option :path,
                      :aliases  =>  "-p",
                      :desc     =>  "The path to the pool", 
                      :required =>  true,
                      :type     =>  :string
        def pool
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu///system"
            end
            connection = Rupert.connect(conn).host
            pool = connection.find_pool(options[:name])
            pool.path ||= options[:path]
            pool.save
          rescue => e
            puts "#{e.message}"
          end
        end

        desc "nic","Modifies a network interface"
        method_option :name, 
                      :aliases  =>  "-n", 
                      :desc     =>  "The name of the thing you are going to create", 
                      :required =>  true,
                      :type     =>  :string

        method_option :connection, 
                      :aliases  =>  "-c", 
                      :desc     =>  "The connection to Libvirt", 
                      :required =>  false,
                      :type     =>  :string

        method_option :dhcp, 
                      :desc     =>  "enable DHCP on the device", 
                      :required =>  false,
                      :type     =>  :boolean

        method_option :conntype,  
                      :desc     =>  "The type of connection. Ethernet, Bridge, etc", 
                      :required =>  false,
                      :type     =>  :string

        method_option :mac, 
                      :desc     =>  "The MAC address of the device", 
                      :required =>  false,
                      :type     =>  :string

        method_option :ip, 
                      :desc     =>  "The IP address of the device", 
                      :required =>  false,
                      :type     =>  :string

        method_option :onboot, 
                      :desc     =>  "Set the device to boot on startup", 
                      :default  =>  true,
                      :required =>  false,
                      :type     =>  :boolean

        method_option :ipPrefix, 
                      :desc     =>  "The IP prefix of the device", 
                      :required =>  false,
                      :type     =>  :string

        method_option :bridgeIfaceName, 
                      :desc     =>  "The name of the bridge interface", 
                      :required =>  false,
                      :type     =>  :string

        method_option :bridgeIfaceType, 
                      :desc     =>  "The device type of the bridge interface", 
                      :required =>  false,
                      :type     =>  :string

        def nic
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu///system"
            end
            connection = Rupert.connect(conn).host
            nic = connection.find_nic(options[:name])
            nic.dhcp            ||= options[:dhcp]
            nic.conntype        ||= options[:conntype]
            nic.mac             ||= options[:mac]
            nic.ip              ||= options[:ip]
            nic.onboot          ||= options[:onboot]
            nic.ipPrefix        ||= options[:ipPrefix]
            nic.bridgeIfaceName ||= options[:bridgeIfaceName]
            nic.bridgeIfaceType ||= options[:bridgeIfaceType]
          rescue => e
            puts "#{e.message}"
          end
        end

      end
    end
  end
end

