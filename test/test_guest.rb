require 'test/unit'
require 'rupert'

class Rupert::TestGuest < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
    name = "test_guest"
    iso = "/vmstore/isos/CentOS-6.3-x86_64-bin-DVD1.iso"
    @guest = Rupert::Guest.new({:name => "#{name}-#{Time.now.to_i}", :iso_file => iso})
  end

  def test_should_be_new
    assert @guest.new?
  end

  def teardown
    @guest.volume.destroy
    @guest.destroy
  end 

  def test_should_save
    assert @guest.save
  end

  def test_should_fail_start_before_save
    assert_raise ( Rupert::Errors::GuestNotCreated ) { @guest.start }
  end

  def test_should_destroy
    assert @guest.destroy
  end

  def test_should_create_and_destroy_volume
    assert @guest.volume.save
    assert @guest.volume.destroy
  end

  def test_should_fail_on_two_volume_save
    assert @guest.volume.save
    assert_raise ( RuntimeError ) { @guest.volume.save }
  end

  def test_should_create_and_save_volume_and_guest
    assert @guest.volume.save
    assert @guest.save
  end

  def test_should_save_and_run_and_destroy
    assert @guest.volume.save
    assert @guest.save
    assert @guest.start
    assert @guest.running?
    assert @guest.force_shutdown
  end

  def test_should_shutdown
    assert @guest.volume.save
    assert @guest.save
    assert @guest.start
    assert @guest.force_shutdown
  end

  def test_should_start
    assert @guest.volume.save
    assert @guest.save
    assert @guest.start
  end

  def test_should_restart
    assert @guest.volume.save
    assert @guest.save
    assert @guest.start
    assert @guest.restart
  end

end
