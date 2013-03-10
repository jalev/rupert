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

  def test_should_raise_on_no_name
    assert_raise ( RuntimeError ){
      @guest = Rupert::Guest.new()
    }
  end

  def test_should_raise_start_before_save
    assert_raise ( Rupert::Errors::GuestNotCreated ){ @guest.start }
  end

  def test_should_raise_shutdown_not_running
    assert_raise ( Rupert::Errors::GuestNotStarted){
      @guest.volume.save
      @guest.save
      @guest.shutdown
    }
  end

  def test_should_raise_force_shutdown_not_running
    assert_raise ( Rupert::Errors::GuestNotStarted ){
      @guest.volume.save
      @guest.save
      @guest.force_shutdown
    }
  end

  def test_should_raise_resume_not_saved
    assert_raise ( Rupert::Errors::GuestNotCreated ){
      @guest.resume
    }
  end

  def test_should_raise_resume_already_running
    assert_raise ( Rupert::Errors::GuestAlreadyRunning){
      @guest.volume.save
      @guest.save
      @guest.start
      @guest.resume
    }
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

  def test_should_find_already_existing_guest
    assert @guest.volume.save
    assert @guest.save
    tempguest = Rupert::Guest.new(:name => @guest.name)
    assert @guest.uuid == tempguest.uuid
  end

  def test_should_update_already_existing_guest
    assert @guest.save
    @guest.ram = 1024
    assert @guest.save
  end

  def test_should_raise_on_modification_while_running
    assert @guest.volume.save
    assert @guest.save
    assert @guest.start
    @guest.ram = 1000
    assert_raise ( Rupert::Errors::GuestIsRunning ){ 
      @guest.save
    }
  end

  def test_create_volume_with_capacity
    @guest = Rupert::Guest.new(:name => @guest.name, :volume => {:capacity => 10})
    assert_equal( 10, @guest.volume.capacity )
  end

  def test_create_volume_with_different_name_than_guest
    @guest = Rupert::Guest.new(:name => @guest.name, :volume => {:name => "test_name"})
    assert_equal( "test_name", @guest.volume.name )
    assert @guest.volume.save
    assert @guest.save
  end

end
