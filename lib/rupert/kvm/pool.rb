require 'libvirt'

module Rupert::KVM

  class Pool < Rupert::Pool

    include Rupert::Utility

    def default_template_path
      "kvm/pool.xml.erb"
    end

  end

end
