require 'test/unit'
require 'rupert'

class Rupert::TestHost < Test::Unit::TestCase

  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    @host = Rupert.open(uri).host
  end

  def test_should_return_network_interfaces
    puts @host.list_interfaces.inspect
    assert @host.list_interfaces
  end

end
