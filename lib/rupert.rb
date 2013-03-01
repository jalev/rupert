require 'rupert/rupert'
require 'rupert/utility'
require 'rupert/connect'
require 'rupert/host'
require 'rupert/pool'
require 'rupert/volume'

module Rupert

  # One of Ruby's quick features. Using class << self sets up a metaparameter
  # 
  class << self

    def active_connection
      @connection 
    end

    def open uri
      @connection = Rupert::Connect.new(uri)
    end 

  end
end 
