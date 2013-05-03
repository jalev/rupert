require 'thor'
require 'rupert'
require 'tempfile'

module Rupert
  class CLI < Thor
    module Commands
      class List < Thor
  

        desc "vms", "lists vms"
        
        method_option :all,
                      :desc     =>  "List all vms, including inactive",
                      :type     =>  :boolean
 
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
        
        def nics
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu:///system"
            end
            connection = Rupert.connect(conn)
            vms = connection.host.list_guests
            puts "ID\t\t\t\t| Name\t\t\t\t| RAM\t\t\t\t| Disk\t\t\t\t| State"
            vms.each do | vm |
              puts "#{vm.id}\t\t\t\t#{vm.name}\t\t\t\t#{vm.ram}\t\t\t\t#{vm.disk.size}\t\t\t\t#{vm.state}"
            end
            if all
              vms = connection.host.list_inactive_guests
              vms.each do | vm |
                puts "#{vm.id}\t\t\t\t#{vm.name}\t\t\t\t#{vm.ram}\t\t\t\t#{vm.disk.size}\t\t\t\t#{vm.state}"
              end
            end
          rescue => e
            puts "#{e.message}"
          end
        end

        desc "nics", "lists nics"
        
        method_option :all,
                      :desc     =>  "List all nics, including inactive",
                      :type     =>  :boolean
 
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
        
        def nics
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu:///system"
            end
            connection = Rupert.connect(conn)
            nics = connection.host.list_nics
            puts "Name\t\t\t\t| ip-address\t\t\t\t| MAC\t\t\t\t| Type"
            nics.each do | nic |
              puts "#{nic.name}\t\t\t\t#{nic.ip}\t\t\t\t#{nic.mac}\t\t\t\t#{nic.conntype}"
            end
            if all
              nics = connection.host.list_inactive_nics
              nics.each do | nic |
                puts "#{nic.name}\t\t\t\t#{nic.ip}\t\t\t\t#{nic.mac}\t\t\t\t#{nic.conntype}"
              end
            end
          rescue => e
            puts "#{e.message}"
          end
        end

        desc "pools", "lists disks"
        
        method_option :all,
                      :desc     =>  "List all pools, including inactive",
                      :type     =>  :boolean
 
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
        
        def pools
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu:///system"
            end
            connection = Rupert.connect(conn)
            pools = connection.host.list_pools
            puts "Name\t\t\t\t| Path\t\t\t\t"
            pools.each do | pool |
              puts "#{pool.name}\t\t\t\t#{pool.path}"
            end
            if all
              pools = connection.host.list_inactive_pools
              pools.each do | pool |
                puts "#{pool.name}\t\t\t\t#{pool.path}"
              end
            end
          rescue => e
            puts "#{e.message}"
          end
        end

        desc "disks", "lists disks"
        
        method_option :pool,
                      :desc     =>  "the pool to list from",
                      :required =>  true,
                      :type     =>  :string
 
        method_option :connection,
                      :aliases  =>  "-c",
                      :desc     =>  "The connection to the libvirt host", 
                      :required =>  false,
                      :type     =>  :string
        
        def disks
          begin
            conn = options[:connection]
            if !conn
              conn = "qemu:///system"
            end
            connection = Rupert.connect(conn)
            disks = connection.host.list_disks(:pool => options[:pool])
            puts "Name\t\t\t\t| Allocation\t\t\t\t\| Size\t\t\t\t| Path\t\t\t\t| Key"
            disks.each do | disk |
              puts "#{disk.name}\t\t\t\t#{disk.alloc}\t\t\t\t#{disk.size}\t\t\t\t#{disk.path}\t\t\t\t#{disk.key}"
            end
          rescue => e
            puts "#{e.message}"
          end
        end

      end
    end
  end
end

