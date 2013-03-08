Gem::Specification.new do |s|
  s.name        = 'porter'
  s.version     = '0.1.0.alpha'
  s.date        = '2013-03-03'
  s.executables << 'porter'
  s.summary     = "The easy way to forward ports using IP Tables"
  s.description = "This gem allows you to forward ports from any machine that can run iptables and ruby"
  s.authors     = ["Robert McLeod"]
  s.email       = 'hamstar@telescum.co.nz'
  s.files       = Dir.glob("{bin,lib}/**/*") + $w(README.md)
  s.homepage    = 'https://github.com/hamstar/porter'
end
