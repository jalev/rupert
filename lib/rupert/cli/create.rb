module Rupert
  class CLI < Thor
    module Commands
      class Create < Thor

        desc "vm ","Creates a virtual machine."
      
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
      
        method_option :no_vnc,
                      :desc         =>  "set an option to suppress vnc on startup",
                      :required     =>  false,
                      :type         =>  :boolean,
                      :default      =>  :false
      
        def vm 
      #    begin
            conn = options[:connection]
            if !conn
              conn = "qemu:///system"
            end
            
            @connection = Rupert::connect(conn)
            @vm = Rupert::Guest.new(options)
            if options[:kickstart]
              @vm.write_kickstart
            end
            raise Rupert::Errors::GuestAlreadyExist.new if !@vm.new?
            @vm.volume.save if @vm.volume.new?
            @vm.save
            @vm.start
            if options[:remote]
              @vm.delete_tmp_file(@vm.initrdtmp)
              @vm.delete_tmp_file(@vm.kerneltmp)
              #@vm.cmdargs = nil
              #@vm.kerneltmp = nil
              #@vm.initrdtmp = nil
              #@vm.kickstart = nil 
              #@vm.remote = nil
              #@vm.save
              #puts @vm
              #puts @vm.updated?
            end
            system("vncviewer :#{@vm.get_vnc_port}")
      
      
      #    rescue => e
      #      puts "#{e.message}"
      #    end
        end
      
        desc "disk","Creates a disk"
        method_option :name, 
                      :aliases  =>  "-n", 
                      :desc     =>  "The name of the thing you are going to create", 
                      :required =>  true,
                      :type     =>  :string
      
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
      
        method_option :size,
                      :banner       =>  "GB",
                      :desc         =>  "The size of the disk, in GB",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :alloc,
                      :banner       =>  "GB",
                      :desc         =>  "The amount of disk immediately allocated, in GB",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :type,
                      :desc         =>  "The type of disk you wish to create. Options are 'Raw' and 'QCOW2'",
                      :default      =>  "qcow2",
                      :lazy_default =>  "qcow2",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :pool,
                      :desc         =>  "The pool you wish to create this disk on",
                      :lazy_default =>  "default",
                      :required     =>  false,
                      :type         =>  :string
      
        def disk
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu+ssh://root@localhost/system"
            end
            @connection = Rupert::connect(conn)
            @volume = Rupert::Volume.new(options)
            raise Rupert::Errors::DiskAlreadyExist if !@volume.new?
            @volume.save
          rescue => e
            puts "#{e}"
          end
        end
      
        desc "pool","Creates a pool"
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
      
    
        def pool
        end

      end
    end
  end
end



