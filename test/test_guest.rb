require 'test/unit'
require 'rupert'

class Rupert::TestGuest < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
    name = "test_guest"
    iso = "/vmstore/isos/CentOS-6.3-x86_64-bin-DVD1.iso"
    @guest = Rupert::Guest.new(:name => name, :iso_file => iso)
  end

  def test_should_create
    puts @guest.volume
    assert @guest.save
    #@guest.destroy
  end

#  def test_should_destroy
#    @volume.save
#    assert @volume.destroy
#  end

end
