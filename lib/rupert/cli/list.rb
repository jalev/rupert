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
      end
    end
  end
end

