require 'test/unit'
require 'rupert'

class Rupert::TestConnect < Test::Unit::TestCase
  def setup 
    uri = ""
    @connection = Rupert::Connect.new uri 
  end

  def test_should_connect
    assert !@connection.closed?
  end

  def test_should_close
    @connection.disconnect_from_hypervisor
    assert @connection.closed?
  end

end
