module Rupert
  class CLI < Thor
    module Commands
      class Delete < Thor
        desc "vm ","Deletes a virtual machine."
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
      
        def vm
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu+ssh://root@localhost/system"
            end
            @connection = Rupert::connect(conn)
            @vm = Rupert::Guest.new(options)
            @vm.destroy
          rescue => e
            puts "#{e}"
          end
        end
      
        desc "disk", "Deletes a disk."
        method_option :name, 
                      :aliases  =>  "-n", 
                      :desc     =>  "The name of the thing you are going to delete", 
                      :required =>  true,
                      :type     =>  :string
      
        method_option :pool,
                      :aliases  =>  "-p", 
                      :desc     =>  "The name of the storage pool you are going to delete from", 
                      :default  =>  "default",
                      :required =>  false,
                      :type     =>  :string
      
        def disk
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu+ssh://root@localhost/system"
            end
            @connection = Rupert::connect(conn)
            @disk = Rupert::Volume.new(options)
            @disk.destroy
          rescue => e
            puts "#{e}"
          end
        end
      end
    end
  end
end
