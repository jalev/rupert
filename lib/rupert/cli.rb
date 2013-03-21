require 'thor'
require 'rupert'

module Rupert

  class Create < Thor
    desc "vm <options>", "Creates a virtual machine somehting"
    def vm (what)
      puts "test, #{what}"
    end
  end

  class CLI < Thor
    desc "create SUBCOMMAND", "create a something"
    subcommand "create", Create
  end


end
