require 'test/unit'
require 'rupert'

class Rupert::TestDisk < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    @host = Rupert.connect(uri).host
  end

  def test_should_return_nics
    assert 
  end

  def test_should_have_name
    assert_kind_of String, @host.name
  end

end
