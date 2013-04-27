module Rupert
  module NetInstall
    require 'facter'
    require 'erb'
    require 'tempfile'
    require 'net/http'
    require 'uri'
    require 'securerandom'
    require 'fileutils'

    include Rupert::Config

    attr_reader :provisioner_ip, :provisioner_hostname, :kickstart_file

    def write_kickstart
      raise Rupert::Errors::RequireRemoteURL if @remote.nil?
      raise Rupert::Errors::NoOSSpecified if @os.nil?
      get_config_file

      kickstart_file = "#{@os}-kickstart#{SecureRandom.hex}.cfg"
      kickstart_template = @os
      kickstart = File.read("#{File.dirname __FILE__}/./templates/kickstart/#{kickstart_template}.erb")
      @kickstart_template = ERB.new(kickstart, nil, '-').result(binding)

      File.open("#{@config_dir}/os/#{@os}/kickstart/#{kickstart_file}", 'wb') do | file |
        file.write @kickstart_template
      end

      @kickstart_file = "#{provisioner_ip}/rupert/#{kickstart_file}"
    end

    def is_url?(url)
      url.start_with?("http://") || url.start_with?("https://")
    end

    def download_file(url, file, to_write)
      raise Rupert::Errors::NotValidURL if !is_url?(url) || is_url?(url) && !url.end_with?("/")
      raise Rupert::Errors::RequireRemoteURL if @remote.nil?
      raise Rupert::Errors::NoOSSpecified if @os.nil?
      tmp = get_prereq(url, file, to_write)
      return tmp
    end

    def initrd_exist?
      File.exist?("#{@config_dir}/os/#{@os}/initrd.img")
    end

    def kernel_exist?
      File.exist?("#{@config_dir}/os/#{@os}/vmlinux")
    end

    def delete_initrd
      f = "#{@config_dir}/os/#{@os}/initrd.img"
      return if !File.exist?(f)
      File.delete(f)
    end

    def delete_kernel
      f = "#{@config_dir}/os/#{@os}/vmlinux"
      return if !File.exist?(f)
      File.delete(f)
    end

    private 

    # Get the prerequisit remote files. We need this if a remote installation
    # occurs
    #
    def get_prereq(url, resource, file)
      return file if File.exist?(file)

      ## Ensure directory structure exists
      #
      directory_structure = File.join("#{@config_dir}", "os", "#{@os}") 
      FileUtils.mkpath(directory_structure) unless Dir.exists?(directory_structure)

      uri = URI.join(url, resource)
      directory = uri.path

      thing = File.new(file,'wb')
      begin
        Net::HTTP.start(uri.host, uri.port) do | http |
          req = Net::HTTP::Get.new(directory)
          resp = http.request(req)
          thing.write(resp.body)
        end
      rescue SocketError => e
        puts e.message
      end
      return thing.path
    end

    def provisioner_ip
      Facter.ipaddress
    end

    def provisioner_hostname
      Facter.fqdn
    end

    def default_kickstart_template
      "centos"
    end

    def default_host
      "webapp.rupert.provisioning.io"
    end

  end
end
