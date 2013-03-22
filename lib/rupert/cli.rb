require 'thor'
require 'rupert'

module Rupert

  class Create < Thor
    desc "vm ","Creates a virtual machine."

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

    method_option :os,
                  :desc         =>  "The type of OS to install.",
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
                  :required     =>  false,
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
        @connection = Rupert::connect(options[:connection])
      rescue => e
        puts "#{e}"
      end
      #Rupert::Guest.new(options)
    end

    desc "disk","Creates a disk"
    def disk (what)
    end

    desc "pool","Creates a pool"
    def pool (what)
    end

  end

  class CLI < Thor
    desc "create SUBCOMMAND", "create a something"
    subcommand "create", Create

    desc "start", "starts a virtual machine"
    def start
    end
  end


end
