require 'test/unit'
require 'rupert'

class Rupert::TestGuest < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    name = "test_guest"
    iso = "/vmstore/isos/CentOS-6.3-x86_64-bin-DVD1.iso"
    @connection = Rupert.connect(uri).host
    @guest = @connection.create_guest(:name => "#{name}-#{Time.now.to_i}", :iso_file => iso)

    #@guest = Rupert::Guest.new({:name => "#{name}-#{Time.now.to_i}", :iso_file => iso})
  end

  def test_should_be_new
    assert @guest.new?
  end

  def teardown
    if @guest.kernel_exist?
      @guest.delete_kernel
    end
    if @guest.initrd_exist?
      @guest.delete_initrd
    end
    @guest.disk.delete 
    @guest.delete
  end 

  def test_should_save
    assert @guest.save
  end

  def test_should_raise_with_no_name
    assert_raise(Rupert::Errors::MissingRequiredAttribute){
      @guest.name = nil
      @guest.save
    }
  end

  def test_should_raise_with_weird_name
    assert_raise(Rupert::Errors::DefinitionError){
      @guest.name = "\\`\\\//3$$$@!#*(&^%$#"
      assert @guest.save
    }
  end

  def test_should_create_disk
    @guest.disk.size = 10
    assert @guest.disk.save
    assert @guest.save
    assert_equal(10, @guest.disk.size)
  end

  def test_should_raise_on_no_name
    assert_raise ( Rupert::Errors::MissingRequiredAttribute ){
      @guest = Rupert::Guest.new()
    }
  end

  def test_should_raise_on_empty_name_string
    assert_raise ( Rupert::Errors::DefinitionError){
      @guest.name = ""
      @guest.save
    }
  end

  def test_should_raise_start_before_save
    assert_raise ( Rupert::Errors::GuestNotCreated ){ @guest.start }
  end

  def test_should_raise_shutdown_not_running
    assert_raise ( Rupert::Errors::GuestNotStarted){
      @guest.disk.save
      @guest.save
      @guest.shutdown
    }
  end

  def test_should_raise_force_shutdown_not_running
    assert_raise ( Rupert::Errors::GuestNotStarted ){
      @guest.disk.save
      @guest.save
      @guest.force_shutdown
    }
  end

  def test_should_raise_if_ram_is_zero
    assert_raise ( Rupert::Errors::GuestNeedsRam) {
      @guest.ram = 0
      @guest.save
    }
  end

  def test_guest_should_run_on_four_megabytes_of_ram
    @guest.ram = 4
    assert @guest.save
    assert @guest.start
  end

  def test_should_raise_if_disk_is_zero
    assert_raise ( Rupert::Errors::DiskCannotBeZero){
      @guest.disk.size = 0 
      @guest.disk.alloc = 0
      @guest.disk.save
    }
  end

  def test_should_raise_resume_not_saved
    assert_raise ( Rupert::Errors::GuestNotCreated ){
      @guest.resume
    }
  end

  def test_should_raise_resume_already_running
    assert_raise ( Rupert::Errors::GuestAlreadyRunning){
      @guest.save
      @guest.start
      @guest.resume
    }
  end

  def test_should_delete
    assert @guest.delete
  end

  def test_should_create_and_delete_disk
    assert @guest.disk.save
    assert @guest.disk.delete
  end

  def test_should_create_and_save_disk_and_guest
    assert @guest.disk.save
    assert @guest.save
  end

  def test_should_run_with_disk
    assert @guest.disk.save
    assert @guest.save
    assert @guest.start
  end

  def test_should_save_and_run_and_destroy
    assert @guest.save
    assert @guest.start
    assert @guest.running?
    assert @guest.force_shutdown
  end

  def test_should_shutdown
    assert @guest.save
    assert @guest.start
    assert @guest.force_shutdown
    assert_equal("Shut Off", @guest.state)
  end

  def test_should_start
    assert @guest.save
    assert @guest.start
    assert_equal("Running", @guest.state)
  end

  def test_should_restart
    assert @guest.save
    assert @guest.start
    assert @guest.restart
  end

  def test_should_find_already_existing_guest
    assert @guest.save
    tempguest = Rupert::Guest.new(:name => @guest.name)
    assert_equal(@guest.uuid, tempguest.uuid)
  end

  def test_should_update_already_existing_guest
    assert @guest.save
    @guest.ram = 1024
    assert @guest.save
    assert_equal(1024, @guest.ram)
  end

  def test_create_disk_with_capacity
    @guest = Rupert::Guest.new(:name => @guest.name, :disk_size => 10)
    assert_equal( 10, @guest.disk.size)
  end

  def test_create_disk_with_different_name_than_guest
    name = "test_name-#{Time.now.to_i}"
    @guest = Rupert::Guest.new(:name => @guest.name, :disk_name => name)
    assert_equal( name, @guest.disk.name )
    assert @guest.disk.save
    assert @guest.save
  end

#  def test_guest_with_remote_install
#    @guest.remote = "http://centos.arcticnetwork.ca/6/os/x86_64/"
#    @guest.os = "centos"
#    assert @guest.save
#    assert_equal("method=http://centos.arcticnetwork.ca/6/os/x86_64/", @guest.cmdargs)
#    assert @guest.initrd_exist?
#    assert @guest.kernel_exist?
#  end
#
#  def test_guest_with_remote_and_existing_kernel
#    @guest.remote = "http://centos.arcticnetwork.ca/6/os/x86_64/"
#    @guest.os = "centos"
#    assert @guest.save
#    assert @guest.initrd_exist?
#    assert @guest.kernel_exist?
#    # The second save should look for existing downloaded kernel
#    assert @guest.save
#    assert @guest.initrd_exist?
#    assert @guest.kernel_exist?
#  end
#
#  def test_guest_with_remote_false_url
#    assert_raise(Rupert::Errors::NotValidURL){
#      @guest.remote = "not valid url"
#      @guest.os = "centos"
#      @guest.save
#    }
#  end
#  def test_exception_on_remote
#    assert_raise(Rupert::Errors::NoOSSpecified){
#      @guest.remote = "http://centos.arcticnetwork.ca/6/os/x86_64/"
#      @guest.save
#    }
#  end

end
