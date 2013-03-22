require 'test/unit'
require 'rupert'

class Rupert::TestPool < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
  end

  def test_should_create
  end

  def test_should_destroy
  end

end
