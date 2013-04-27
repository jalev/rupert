module Rupert
  class CLI < Thor
    module Commands
      class Debug < Thor

        desc "vm-create", "Creates a virtual machine"
        method_option :name, 
                      :aliases  =>  "-n", 
                      :desc     =>  "The name of the thing you are going to create", 
                      :required =>  true,
                      :type     =>  :string
    
        method_option :remote,
                      :desc         =>  "Information about the remote installer",
                      :required     =>  false,
                      :type         =>  :string
    
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
    
        method_option :save,
                      :alias    =>  "-s",
                      :desc     =>  "Save virtual machine",
                      :type     =>  :boolean
                      
        method_option :run,
                      :alias    =>  "-r",
                      :desc     =>  "Save virtual machine",
                      :type     =>  :boolean
                      
        method_option :disk,
                      :alias    =>  "-d",
                      :desc     =>  "Save virtual machine",
                      :type     =>  :boolean
                      
        method_option :kickstart,
                      :alias    =>  "-k",
                      :desc     =>  "Save virtual machine",
                      :type     =>  :boolean
                      
    
        def vm_create
          conn = options[:connection]
          if !conn
            conn = "qemu+ssh://root@localhost/system"
          end
          @connection = Rupert::connect(conn)
          @vm = Rupert::Guest.new(options)
          @vm.os = "centos"
          puts options
          @vm.write_kickstart
          puts @vm.kickstart_template
          case options
          when options[:disk] == true
            @vm.volume.save
          when options[:kickstart] == true
            @vm.write_kickstart
            puts @vm.kickstart_file
          when options[:save] == true
            @vm.save
          when options[:run] == true
            @vm.start
            system("vncviewer :#{@vm.get_vnc_port}")
          end
        end
      end
    end
  end
end


