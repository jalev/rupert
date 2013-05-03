require 'libvirt'
require 'rupert/utility' #ensure the utility class is actually loaded 

module Rupert::KVM
  
  # Guest class contains specific functions for the creation and destruction
  # of 'Guests'. The actual call to create the guests are handled by the host.
  #
  class Guest < Rupert::Guest
    
    def initialize options={}
      @connection = Rupert.connection
      @name = options[:name] || raise("Missing attribute: Name") unless options[:id] || options[:uuid]

      find_guest_by_name 
      # If we have found the guest, then we have no need to set the values,
      # otherwise...
      #
      # Required values
      @cpu          ||= options[:cpu] || default_vcpu
      @ram          ||= options[:ram] || default_ram
      @os_type      ||= options[:os_type] || default_os_type
      @os           =   options[:os]
      @hostname     ||= options[:hostname] 
      @domain_type  ||= options[:domain_type] || default_domain_type
      @arch         ||= options[:arch] || default_arch
      @pool         =   options[:pool] || default_pool
      @display_type ||= options[:display_type] || default_display_type
      @display_port ||= options[:display_port] || default_display_port

      # Optional Values
      #
      @cmdargs      ||=   options[:cmdargs]
      @iso          ||=   options[:iso]
      @kickstart    ||=   options[:kickstart] 
      @remote       ||=   options[:remote]
      @template_path =  options[:template_path] || default_template_path
      @root_pass    =   options[:root_pass]
      
      # We want to be able to pass seperate volume commands at object
      # instanciation. 
      #
      if options[:disk_name] || @disk_name
        volname = {:name => options[:disk_name]}
      else
        volname = {:name => @name} 
      end
      volops = {:size => options[:disk_size], :alloc => options[:disk_alloc],
                :pool =>  options[:pool], :format => options[:disk_format]}

      volops = volops.merge(volname)
      @disk = @connection.host.create_disk(volops)

    end

    def default_template_path
      "kvm/guest.xml.erb"
    end

  end
end
