require 'libvirt'
require 'rupert/utility' #ensure that the utility class is actuall loaded

module Rupert::KVM
  class Disk < Rupert::Disk
    include Rupert::Utility

    def default_template_path
      "kvm/volume.xml.erb"
    end

  end
end
