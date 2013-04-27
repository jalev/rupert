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

    def list_vms

     # begin
        conn = options[:connection]
        if !conn
          conn = "qemu+ssh://root@localhost/system"
        end
        @connection = Rupert::connect(conn)
        puts " id\t\tName\t\t\tState"
        puts "----------------------------------------------------"
        @connection.host.list_guests.each do | vm |
          puts " #{vm.id}\t\t#{vm.name}\t\t#{vm.state}"
        end
        if options[:all]
          @connection.host.list_inactive_guests.each do |vm|
            puts " -\t\t#{vm.name}\t\t#{vm.state}"
          end
        end
        puts "\n"
     # rescue => e
     #   puts "#{e.message}"
     # end

    end

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
          conn = "qemu+ssh://root@localhost/system"
        end
        @connection = Rupert::connect(conn)
        @vm = Rupert::Guest.new(:name => options[:name])
        raise Rupert::Errors::GuestIsRunning
        @vm.start
      rescue => e
        puts "#{e.message}"
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
          conn = "qemu+ssh://root@localhost/system"
        end
        @connection = Rupert::connect(conn)
        @vm = Rupert::Guest.new(:name => options[:name])
        raise Rupert::Errors::GuestIsNotRunning if !@vm.running?
        @vm.shutdown
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
          conn = "qemu+ssh://root@localhost/system"
        end
        @connection = Rupert::connect(conn)
        @vm = Rupert::Guest.new(:name => options[:name])
        @vm.restart
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
          conn = "qemu+ssh://root@localhost/system"
        end
        @connection = Rupert::connect(conn)
        @vm = Rupert::Guest.new(:name => options[:name])
        raise Rupert::Errors::GuestIsNotRunning if !@vm.running?
        @vm.suspend
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
        @connection = Rupert::connect(conn)
        @vm = Rupert::Guest.new(:name => options[:name])
        raise Rupert::Errors::GuestIsNotRunning if !@vm.running?
        @vm.force_shutdown
      rescue => e
        puts "#{e.message}"
      end
    end


  end


end
