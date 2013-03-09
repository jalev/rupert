require 'rupert/utility'
require 'rupert/connect'
require 'rupert/volume'
require 'rupert/guest'
require 'rupert/host'
require 'rupert/pool'
require 'rupert/exceptions'

module Rupert

  class << self

    def connection 
      return @connection
    end

    def connect uri 
      @connection = Rupert::Connect.new(uri)
    end 

  end
end
