require 'libvirt'
require 'rupert/utility'

module Rupert
  class Nic < Rupert::Nic
    include Rupert::Utility

    def default_template_path
      "kvm/nic.xml.erb"
    end

  end
end
