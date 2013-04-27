require 'libvirt'
require 'rupert/utility'

module Rupert
  class Nic
    include Rupert::Utility

    attr_accessor :name
    attr_accessor :dhcp
    attr_accessor :conntype
    attr_accessor :mac
    attr_accessor :ip
    attr_accessor :onboot
    attr_accessor :ipPrefix
    attr_accessor :bridgeIfaceName
    attr_accessor :bridgeIfaceType
    attr_accessor :gateway
    attr_accessor :template_path

    attr_reader :xml_desc

    def initialize options = {}
      @connection = Rupert.connection
      @name = options[:name] || raise(Rupert::Errors::AttributeNotExist)
      get_nic_info
      @conntype = options[:conntype] || default_interface_type
      @mac = options[:mac]
      @dhcp = options[:dhcp]
      @onboot = options[:onboot] 
      @mac = options[:mac]
      @ip = options[:ip] unless dhcp 
      @ipPrefix = options[:ipPrefix] unless dhcp
      @bridgeIfaceType = options[:bridgeIfaceType]
      @bridgeIfaceName = options[:bridgeIfaceName]
      @template_path = options[:template_path] || default_template_path
    end

    def new?
      @nic.nil?
    end

    def save
      @nic = @connection.raw.define_interface_xml(xml_template)
      @xml_desc = @nic.xml_desc
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

    def default_template_path
      "nic.xml.erb"
    end

    def active?
      @nic.active?
    end

    def to_s
      puts @nic.xml_desc
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
      @conntype = value_from_xml("interface", "type")
      @onboot = value_from_xml("interface/start", "mode") 
      @ip = value_from_xml("interface/protocol/ip", "address")
      @mac = value_from_xml("interface/bridge/interface/mac", "address")
      @bridgeIfaceType = value_from_xml("interface/bridge/interface", "type")
      @bridgeIfaceName = value_from_xml("interface/bridge/interface", "name")
    end

  end
end
