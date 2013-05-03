require 'thor'
require 'rupert'
require 'rupert/cli/list'
require 'rupert/cli/create'
require 'rupert/cli/edit'
require 'rupert/cli/delete'
require 'rupert/cli/list'
require 'rupert/cli/debug'
require 'tempfile'

module Rupert



  class CLI < Thor

    desc "list SUBCOMMAND", "list a something"
    subcommand "list", CLI::Commands::List

    desc "create SUBCOMMAND", "create a something"
    subcommand "create", CLI::Commands::Create

    desc "delete SUBCOMMAND", "delete a something"
    subcommand "delete", CLI::Commands::Delete

    desc "edit SUBCOMMAND", "edit a thing,"
    subcommand "edit", CLI::Commands::Edit

    desc "debug SUBCOMMAND", "debugging"
    subcommand "debug", CLI::Commands::Debug

    desc "start", "starts a virtual machine"
    method_option :name, 
                  :aliases  =>  "-n", 
                  :desc     =>  "The name of the thing you are going to create", 
                  :required =>  true,
                  :type     =>  :string

    method_option :connection,
                  :aliases  =>  "-c",
                  :desc     =>  "The connection to the libvirt host", 
                  :required =>  false,
                  :type     =>  :string

    def start
      begin
        conn = options[:connection]
        if !conn
          conn = "qemu///system"
        end
        connection = Rupert::connect(conn)
        vm = connection.host.find_guest(options[:name])
        vm.start
      rescue => e
        puts "#{e}"
      end
    end

    desc "shutdown", "shutdown a virtual machine"
    method_option :name, 
                  :aliases  =>  "-n", 
                  :desc     =>  "The name of the virtual machine",
                  :required =>  true,
                  :type     =>  :string

    method_option :connection,
                  :aliases  =>  "-c",
                  :desc     =>  "The connection to the libvirt host", 
                  :required =>  false,
                  :type     =>  :string

    def shutdown
      begin
        conn = options[:connection]
        if !conn
          conn = "qemu///system"
        end
        connection = Rupert::connect(conn)
        vm = connection.host.find_guest(options[:name])
        vm.shutdown
      rescue => e
        puts "#{e.message}"
      end
    end

    desc "restart", "restarts a virtual machine"
    method_option :name, 
                  :aliases  =>  "-n", 
                  :desc     =>  "The name of the thing you are going to create", 
                  :required =>  true,
                  :type     =>  :string

    method_option :connection,
                  :aliases  =>  "-c",
                  :desc     =>  "The connection to the libvirt host", 
                  :required =>  false,
                  :type     =>  :string

    def restart
      begin
        conn = options[:connection]
        if !conn
          conn = "qemu:///system"
        end
        connection = Rupert::connect(conn)
        vm = connection.host.find_guest(options[:name])
        vm.restart
      rescue => e
        puts "#{e.message}"
      end
    end

    desc "pause", "pause a virtual machine"
    method_option :name, 
                  :aliases  =>  "-n", 
                  :desc     =>  "The name of the thing you are going to create", 
                  :required =>  true,
                  :type     =>  :string

    method_option :connection,
                  :aliases  =>  "-c",
                  :desc     =>  "The connection to the libvirt host", 
                  :required =>  false,
                  :type     =>  :string

    def pause
      begin
        conn = options[:connection]
        if !conn
          conn = "qemu///system"
        end
        connection = Rupert::connect(conn)
        vm = connection.host.find_guest(options[:name])
        vm.suspend
      rescue => e
        puts "#{e.message}"
      end
    end

    desc "resume", "resume a virtual machine"
    method_option :name, 
                  :aliases  =>  "-n", 
                  :desc     =>  "The name of the thing you are going to create", 
                  :required =>  true,
                  :type     =>  :string

    method_option :connection,
                  :aliases  =>  "-c",
                  :desc     =>  "The connection to the libvirt host", 
                  :required =>  false,
                  :type     =>  :string

    def pause
      begin
        conn = options[:connection]
        if !conn
          conn = "qemu///system"
        end
        connection = Rupert::connect(conn)
        vm = connection.host.find_guest(options[:name])
        vm.resume
      rescue => e
        puts "#{e.message}"
      end
    end

    desc "stop", "hard-shutdown a virtual machine"
    method_option :name, 
                  :aliases  =>  "-n", 
                  :desc     =>  "The name of the thing you are going to create", 
                  :required =>  true,
                  :type     =>  :string

    method_option :connection,
                  :aliases  =>  "-c",
                  :desc     =>  "The connection to the libvirt host", 
                  :required =>  false,
                  :type     =>  :string

    def stop
      begin
        conn = options[:connection]
        if !conn
          conn = "qemu+ssh://root@localhost/system"
        end
        connection = Rupert::connect(conn)
        vm = connection.host.find_guest(options[:name])
        vm.force_shutdown
      rescue => e
        puts "#{e.message}"
      end
    end

  end


end
