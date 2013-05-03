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
              conn = "qemu///system"
            end
            connection = Rupert::connect(conn).host
            vm = connection.find_guest(options[:name])
            vm.delete
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

        method_option :connection,
                      :aliases  =>  "-c",
                      :required =>  false,
                      :type     =>  :string
      
        method_option :pool,
                      :aliases  =>  "-p", 
                      :desc     =>  "The name of the storage pool you are going to delete from", 
                      :default  =>  "default",
                      :required =>  true,
                      :type     =>  :string
      
        def disk
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu///system"
            end
            connection = Rupert::connect(conn)
            disk =connection.host.find_disk(options[:name])
            disk.delete
          rescue => e
            puts "#{e}"
          end
        end

        desc "pool", "Deletes a pool."
        method_option :name, 
                      :aliases  =>  "-n", 
                      :desc     =>  "The name of the thing you are going to delete", 
                      :required =>  true,
                      :type     =>  :string

        method_option :connection,
                      :aliases  =>  "-c",
                      :required =>  false,
                      :type     =>  :string
      
        def pool
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu///system"
            end
            connection = Rupert::connect(conn)
            pool = connection.host.find_pool(options[:name])
            pool.delete
          rescue => e
            puts "#{e}"
          end
        end

        desc "nic", "Deletes a network interface."
        method_option :name, 
                      :aliases  =>  "-n", 
                      :desc     =>  "The name of the thing you are going to delete", 
                      :required =>  true,
                      :type     =>  :string

        method_option :connection,
                      :aliases  =>  "-c",
                      :required =>  false,
                      :type     =>  :string
      
        def nic
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu///system"
            end
            connection = Rupert::connect(conn)
            nic = connection.host.find_nic(options[:name])
            nic.delete
          rescue => e
            puts "#{e}"
          end
        end
     

      end
    end
  end
end
