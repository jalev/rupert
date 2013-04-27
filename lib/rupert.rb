require 'rupert/exceptions'
require 'rupert/config'
require 'rupert/cli'
require 'rupert/utility'
require 'rupert/netinstall'
require 'rupert/connect'
require 'rupert/disk'
require 'rupert/guest'
require 'rupert/host'
require 'rupert/pool'
require 'rupert/nic'

module Rupert

  class << self

    def connection 
      return @connection if !@connection.closed? and @connection
      raise Rupert::Errors::NoConnectionError
    end

    def connect uri 
      @connection = Rupert::Connect.new(uri)
    end 

  end
end
