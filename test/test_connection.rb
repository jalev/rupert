require 'test/unit'
require 'rupert'

class Rupert::TestConnection < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    @hypervisor = "kvm"
    @connection = Rupert.connect(uri)
  end

  def teardown
    @connection.disconnect if !@connection.closed?
  end

  def test_can_connect
    assert @connection
  end

  def test_can_fail_on_no_connection
    assert_raise(Rupert::Errors::NoHostToConnect){
      uri = nil
      Rupert.connect(uri)
    }
  end

  def test_can_fail_on_bad_connection
    assert_raise(Rupert::Errors::ConnectionError){
      uri = "bad url"
      Rupert.connect(uri)
    }
  end

  def test_can_close
    assert @connection.disconnect
  end

  def test_close
    assert @connection.closed? == false
    @connection.disconnect
    assert @connection.closed? == true
  end

  def test_can_fail_on_no_connect
    assert @connection.disconnect
    assert_raise(Rupert::Errors::NoConnectionError){
      guest = Rupert::Guest.new(:name => "test")
      guest.save
      guest.delete
    }
  end

  def test_raw_connection
    assert @connection.raw.kind_of?(Libvirt::Connect)
  end

  def test_raw_failure
    assert_raise(Rupert::Errors::NoConnectionError){
      @connection.disconnect
      @connection.raw
    }
  end

  def test_can_do_capabilities
    assert @connection.capabilities.kind_of?(Array)
  end

  def test_capabilities_failure
    assert_raise(Rupert::Errors::NoConnectionError){
      @connection.disconnect
      @connection.capabilities
    }
  end

  def test_can_return_host
    assert @connection.capabilities.include?(@hypervisor)
    assert @connection.host.kind_of?(Rupert::KVM::Host)
  end

  def test_can_raise_closed_disconnect
    assert_raise(Rupert::Errors::NoConnectionError){
      @connection.disconnect
      @connection.disconnect
    }
  end

end
