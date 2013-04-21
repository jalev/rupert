require 'test/unit'
require 'rupert'

class Rupert::TestNic < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
    # Nic testing is a little complicated since I have no spare NICs to
    # actually test this properly. As such, I am destroying my NICs.
    #
    @nic = Rupert::Nic.new(:name => "br0", :conntype => "bridge", :onboot => true, 
                           :bridgeIfaceType => "ethernet", :bridgeIfaceName => "eth0")
  end

  def teardown
    @nic.destroy
  end

  def test_should_create
    assert @nic.save
  end

  def test_should_edit
    assert @nic.save
    @nic.bridgeIfaceName = "eth1"
    assert @nic.save
    assert_equal("eth1", @nic.bridgeIfaceName)
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
    assert @nic.stop
  end

  def test_nic_should_be_active
    assert @nic.save
    assert @nic.stop
    assert @nic.start
    assert @nic.active?
    assert @nic.stop
  end

  def test_nic_should_be_inactive
    assert @nic.save
    assert !@nic.active?
  end


end
