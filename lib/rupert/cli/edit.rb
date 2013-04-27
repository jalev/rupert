require 'thor'

module Rupert
  class CLI < Thor
    module Commands
      class Edit < Thor
        desc "vm", "Edits some things with a VM."
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
                      :desc         =>  "The amount of ram the virtual machine should have in MB.",
                      :required     =>  false,
                      :type         =>  :numeric
      
        method_option :cpu,
                      :banner       =>  "CPU",
                      :desc         =>  "The amount of CPUs to attach to the virtual machine.",
                      :required     =>  false,
                      :type         =>  :numeric
      
        method_option :display_type,
                      :desc         =>  "The type of display",
                      :required     =>  false,
                      :type         =>  :string
      
        method_option :display_port,
                      :desc         =>  "The port you wish the display to be available from",
                      :required     =>  false,
                      :type         =>  :numeric
      
        def vm
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu+ssh://root@localhost/system"
            end
            @connection = Rupert::connect(conn)
            @vm = Rupert::Guest.new(:name => options[:name])
            raise Rupert::Errors::GuestIsRunning if @vm.running?
            @vm.ram = options[:ram] 
            @vm.cpu = options[:cpu] 
            @vm.save
          rescue => e
            puts "#{e.message}"
          end

        end
      end
    end
  end
end

