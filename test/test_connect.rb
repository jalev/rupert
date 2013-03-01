require 'test/unit'
require 'rupert'

class Rupert::TestConnect < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    @connection = Rupert::open(uri)
  end

  def test_should_connect
    assert !@connection.closed?
  end

  def test_should_close
    @connection.disconnect
    assert @connection.closed?
  end

end
