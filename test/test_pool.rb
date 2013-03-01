require 'test/unit'
require 'rupert'

class Rupert::TestPool < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    connection = Rupert.open(uri).host
    @pool = Rupert::Pool.new({:name => connection.list_pools.first})
  end

  def test_pool_should_exist
    assert @pool.pool_exist?
  end

end
