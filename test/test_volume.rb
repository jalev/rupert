require 'test/unit'
require 'rupert'

class Rupert::TestVolume < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
    @volume = Rupert::Volume.new(:name => "test_image")
  end

  def test_should_create
    assert @volume.save
    @volume.destroy
  end

  def test_should_destroy
    @volume.save
    assert @volume.destroy
  end

end
