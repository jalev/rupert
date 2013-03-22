require 'test/unit'
require 'rupert'

class Rupert::TestCLI < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
  end

  def test_can_create_virtual_machine
  end

  def test_can_edit_virtual_machine
  end

  def test_can_destroy_virtual_machine
  end

  def test_can_list_virtual_machines
  end

end
