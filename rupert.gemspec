Gem::Specification.new do | s |

  s.name          = 'rupert'
  s.version       = '0.0.1'
  s.date          = '2013-03-21'
  s.summary       = "A virtual machine provisioner"
  s.description   = "Rupert is a virtual machine provisioner designed to work with libvirt"
  s.authors       = ["James Bach"]
  s.email         = 'i7983164@bournemouth.ac.uk'
  s.bindir        = 'bin'
  s.executables   = 'rupert'
  git_files       = `git ls-files`.split("\n") rescue ''
  s.files         = git_files
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

end
