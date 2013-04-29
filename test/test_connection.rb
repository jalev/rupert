require 'test/unit'
require 'rupert'

class Rupert::TestDisk < Test::Unit::TestCase
  def setup 
    uri = "qemu+ssh://root@rupert.provisioning.io/system"
    Rupert.connect(uri)
  end

end
