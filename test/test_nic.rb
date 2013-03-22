require 'test/unit'
require 'rupert'

class Rupert::TestNic < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
    @nic = Rupert::NIC.new()
  end

  def teardown
    @nic.destroy
  end

  def test_should_create
    assert @nic.save
  end

  def test_should_edit
    assert @nic.save
    assert @nic.bridgeIfaceName = "br0"
    assert @nic.save
  end

  def test_should_destroy
    assert @nic.destroy
  end

  def test_should_start
    assert @nic.save
    assert @nic.start
  end

  def test_should_stop
    assert @nic.save
    assert @nic.start
    assert @nic.stop
  end

  def test_nic_should_be_active
    assert @nic.save
    assert @nic.start
    assert @nic.active?
  end

  def test_nic_should_be_inactive
    assert @nic.save
    assert !@nic.active?
  end


end
