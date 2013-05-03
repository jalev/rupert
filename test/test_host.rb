require 'test/unit'
require 'rupert'

class Rupert::TestHost < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    @name = "test-#{Time.now.to_i}"
    @host = Rupert.connect(uri).host
  end

  def test_should_raise_when_create_with_no_name
    assert_raise(ArgumentError){
      @name= ""
      assert @host.create_guest()
    }
  end

  def test_should_return_nic
    assert_kind_of(Rupert::Nic, @host.find_interface("lo"))
  end

  def test_should_return_pool
    assert_kind_of(Rupert::Pool, @host.find_pool("default"))
  end

  def test_should_create_find_and_destroy_guest
    guest = @host.create_guest(:name => "#{@name}")
    assert_kind_of(Rupert::Guest, guest)
    assert guest.save
    assert_kind_of(Rupert::Guest, @host.find_guest("#{@name}"))
    assert guest.delete
  end

  def test_should_return_name
    assert_kind_of(String, @host.name)
  end

  def test_should_list_defined_interfaces
    assert @host.list_interfaces
  end

  def test_should_list_running_guests
    assert @host.list_guests
  end

  def test_should_list_inactive_guests
    assert @host.list_inactive_guests
  end

  def test_should_list_networks
    assert @host.list_networks
  end

  def test_should_list_inactive_networks
    assert @host.list_inactive_networks
  end

  def test_should_list_number_of_inactive_networks
    assert @host.list_number_of_inactive_networks
  end

  def test_should_list_number_of_networks
    assert @host.list_number_of_networks
  end

  def test_should_list_number_of_pools
    assert @host.list_number_of_pools 
  end

  def test_should_list_number_of_inactive_pools
    assert @host.list_number_of_inactive_pools
  end

  def test_should_list_num_of_active_guests
    assert @host.list_number_of_active_guests
  end

  def test_should_list_number_of_inactive_guests
    assert @host.list_number_of_inactive_guests
  end

end
