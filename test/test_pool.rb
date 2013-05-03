require 'test/unit'
require 'rupert'

class Rupert::TestPool < Test::Unit::TestCase

  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    @host = Rupert.connect(uri).host
    @pool = @host.find_pool("default")
    @pool.start if !@pool.active?
  end

  def teardown
    @pool.start if !@pool.active?
  end

  def test_pool_should_not_be_undefined
    assert !@pool.new?
  end

  def test_pool_should_stop
    assert @pool.stop
  end

  def test_pool_should_start
    assert @pool.stop
    assert @pool.start
  end

  def test_pool_should_raise_on_two_stops
    assert_raise(Rupert::Errors::PoolAlreadyStopped){
      @pool.stop
      @pool.stop
    }
  end

  def test_pool_should_perform_disk_operations
    disk = @host.create_disk(:name => "test_disk#{Time.now.to_i}")
    assert disk
    assert disk.save
    assert disk.delete
  end

  def test_pool_should_exist
    assert @pool.exist?
  end

  def test_pool_should_be_active
    assert @pool.active?
  end

  def test_pool_should_build
    assert @pool.stop
    assert @pool.build
  end

  def test_pool_should_raise_on_build
    @pool.start if !@pool.active?
    assert_raise(Rupert::Errors::PoolAlreadyStarted){
      @pool.build
    }
  end

  def test_pool_should_raise_on_start
    assert_raise(Rupert::Errors::PoolAlreadyStarted){
      @pool.start
    }
  end

end
