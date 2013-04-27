require 'test/unit'
require 'rupert'

class Rupert::TestPool < Test::Unit::TestCase

  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    host = Rupert.connect(uri).host
    @pool = Rupert::Pool.new(:name => host.list_pools.first.name)
  end

  def test_pool_should_not_be_undefined
    assert !@pool.new?
  end

end
