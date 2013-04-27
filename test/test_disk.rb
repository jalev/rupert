require 'test/unit'
require 'rupert'

class Rupert::TestDisk < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
    name = "test_image"
    time = Time.now.to_i
    @disk = Rupert::Disk.new(:name => "#{name}-#{time}")
  end

  def teardown
    @disk.delete
  end

  def test_should_create
    assert @disk.save
  end

  def test_should_destroy
    assert @disk.save
    assert @disk.delete
  end

  def test_should_create_large_disk
    @disk.size = 10
    assert @disk.save
    assert_equal(10, @disk.size)
  end

  def test_should_fail_on_already_existing_disk
    assert_raise ( Rupert::Errors::DiskAlreadyExist ){
      @disk.save
      @disk.save
    }
  end

  def test_should_fail_on_bigger_allocation_than_max_size
    assert_raise ( Rupert::Errors::DiskAllocGreaterThanSize ){
      @disk.alloc = 10
      @disk.size = 5
      @disk.save
    }
  end

end
