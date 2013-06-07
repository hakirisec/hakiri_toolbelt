$:.push File.expand_path('../lib', __FILE__)
require 'hakiri/version'

Gem::Specification.new do |s|
  s.name          = 'hakiri'
  s.version       = Hakiri::VERSION
  s.date          = '2013-06-04'
  s.summary       = 'CLI for Hakiri'
  s.description   = 'This is a tool to automate bug hunting.'
  s.authors       = ['Vasily Vasinov']
  s.email         = 'vasinov@me.com'
  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.homepage      = 'http://www.hakiriup.com'
  s.license       = 'MIT'

  s.add_dependency 'commander'
  s.add_dependency 'terminal-table'
end
