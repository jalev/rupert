require 'libvirt'
require 'rupert'
require 'rupert/utility'

module Rupert
  class Nic
    include Rupert::Utility

    attr_reader :name
    attr_reader :type
    attr_reader :mac
    attr_reader :ip


    def initialize options = {}
      @connection = Rupert.active_connection
      @name = options[:name] || raise Rupert::Errors::AttributeNotExist
      @type = options[:type] || default_interface_type
      @mac = options[:mac]
      @dhcp = options[:dhcp]
      @onboot = options[:onboot] 
      @mac = options[:mac]
      @ip = options[:ip] unless dhcp 
      @ipPrefix = options[:ipPrefix] unless dhcp
      @bridgeIfaceType = options[:bridgeIfaceType]
      @bridgeIfaceName = options[:bridgeIfaceName]
    end

    def new?
      @nic.nil?
    end

    def save
      @nic = @connection.define_interface_xml(xmldesc)
      get_nic_info
      !new?
    end

    def start
      raise Rupert::Errors::NicAlreadyRunning if active?
      @nic.create
    end

    def stop
      raise Rupert::Errors::NicNotRunning if !active?
      @nic.destroy
    end

    def destroy
      raise Rupert::Errors::NicNotDefined if new?
      @nic.undefine
    end

    def default_interface_type
      "bridge"
    end

    def active?
      @nic.active?
    end

    private

    def fetch_nic_by_name
      begin
        @connection.raw.lookup_interface_by_name(name)
      rescue Libvirt::RetrieveError
      end
    end

    def get_nic_info
      return if new?
      @xml_desc = @nic.xml_desc
      @name = value_from_xml("interface", "name")
      @type = value_from_xml("interface", "type")
      @onboot = value_from_xml("interface/start", "mode") 
      @ip = value_from_xml("interface/protocol/ip", "address")
      @mac = value_from_xml("interface/bridge/interface/mac", "address")
      @bridgeIfaceType = value_from_xml("interface/bridge/interface", "type")
      @bridgeIfaceName = value_from_xml("interface/bridge/interface", "name")
    end

  end
end
