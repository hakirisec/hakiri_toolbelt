$:.push File.expand_path('../lib', __FILE__)
require 'hakiri/version'

Gem::Specification.new do |s|
  s.name          = 'hakiri'
  s.version       = Hakiri::VERSION
  s.summary       = 'Secure Rails with Hakiri'
  s.description   = 'Hakiri is a CLI for www.hakiriup.com—a cloud security platform for Ruby on Rails apps.'
  s.authors       = ['Vasily Vasinov']
  s.email         = 'vasinov@me.com'
  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.homepage      = 'http://www.hakiriup.com'
  s.license       = 'MIT'

  s.add_dependency 'rake'
  s.add_dependency 'commander'
  s.add_dependency 'terminal-table'
  s.add_dependency 'active_support'
  s.add_dependency 'i18n'
  s.add_dependency 'rest-client'
end
