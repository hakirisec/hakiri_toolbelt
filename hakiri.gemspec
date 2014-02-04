$:.push File.expand_path('../lib', __FILE__)
require 'hakiri/version'

Gem::Specification.new do |s|
  s.name          = 'hakiri'
  s.version       = Hakiri::VERSION
  s.summary       = 'Secure Rails with Hakiri'
  s.description   = 'Hakiri is a CLI for hakiri.io—a cloud security platform for Ruby on Rails apps.'
  s.authors       = ['Vasily Vasinov']
  s.email         = 'vasinov@me.com'
  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.homepage      = 'https://hakiri.io'
  s.license       = 'MIT'

  s.add_dependency 'bundler'
  s.add_dependency 'rake'
  s.add_dependency 'commander'
  s.add_dependency 'terminal-table'
  s.add_dependency 'activesupport'
  s.add_dependency 'i18n'
  s.add_dependency 'rest-client'
  s.add_dependency 'json'

  s.add_development_dependency 'minitest', '~> 5.0.0'
end
