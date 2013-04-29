require 'thor'
require 'rupert'
require 'tempfile'

module Rupert
  class CLI < Thor
    module Commands
      class List < Thor
      
        desc "iface", "Vms"
        def iface
          uri = "qemu+ssh://root@localhost/system"
          host = Rupert.connect(uri).host
          host.list_interfaces.each do | interface |
            puts interface
          end
        end

        desc "disks", "lists disks"
        
        method_option :pool,
                      :desc     =>  "the pool to list from",
                      :required =>  true,
                      :type     =>  :string
        def disks
          uri = "qemu+ssh://root@localhost/system"
          host = Rupert::connect(uri).host
          disks = host.list_disks(:pool => options[:pool])
          disks.each do | disk |
            puts "name: #{disk.name}"
            puts "allocation: #{disk.alloc}"
            puts "size: #{disk.size}"
            puts "path: #{disk.path}"
            puts "key: #{disk.key}"
          end
        end

      end
    end
  end
end

