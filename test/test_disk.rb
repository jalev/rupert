require 'test/unit'
require 'rupert'

class Rupert::TestDisk < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    @host = Rupert.connect(uri).host
    name = "test_image"
    time = Time.now.to_i
    @disk = @host.create_disk(:name => "#{name}-#{time}", :pool => "default")
  end

  def teardown
    @disk.delete
  end

  def test_should_raise_with_weird_name
    assert_raise(Rupert::Errors::DefinitionError){
      @disk.name = "\\`\\\//3$$$@!#*(&^%$#"
      assert @disk.save
    }
  end

  def test_should_raise_when_creating_ten_billion_gigabyte_disk
    assert_raise(Rupert::Errors::DiskLargerThanPool){
      @disk.size = 10000000000
      @disk.save
    }
  end

  def test_should_raise_when_disk_capacity_and_allocation_is_zero
    assert_raise(Rupert::Errors::DiskCannotBeZero){
      @disk.size = 0 
      @disk.alloc = 0
      @disk.save
    }
  end

  def test_should_create
    assert @disk.save
  end

  def test_should_destroy
    assert @disk.save
    assert @disk.delete
  end

  def test_should_grow_larger
    @disk.size = 5
    assert @disk.save
    assert @disk.resize(10)
  end

  def test_should_grow_smaller
    @disk.size = 10
    assert @disk.save
    assert @disk.resize(9)
  end

  def test_should_fail_on_shrinking_past_alloc
    @disk.size = 9
    assert @disk.save
    assert_raise(Rupert::Errors::DiskAllocGreaterThanSize ){
      @disk.resize(5)
    }
  end

  def test_should_create_large_disk
    @disk.size = 10
    assert @disk.save
    assert_equal(10, @disk.size)
  end

  def test_should_fail_on_bigger_allocation_than_max_size
    assert_raise ( Rupert::Errors::DiskAllocGreaterThanSize ){
      @disk.alloc = 10
      @disk.size = 5
      @disk.save
    }
  end

end
