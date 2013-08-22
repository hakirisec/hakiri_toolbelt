module Hakiri

end

require 'terminal-table'
require 'open-uri'
require 'json'
require 'bundler'
require 'bundler/lockfile_parser'

require 'hakiri/cli/cli'
require 'hakiri/cli/system'
require 'hakiri/cli/code'
require 'hakiri/cli/manifest'
require 'hakiri/cli/gemfile'

require 'hakiri/stack'
require 'hakiri/version'
require 'hakiri/http_client'

require 'hakiri/technology'
require 'hakiri/technologies/apache'
require 'hakiri/technologies/apache_tomcat'
require 'hakiri/technologies/java'
require 'hakiri/technologies/jruby'
require 'hakiri/technologies/linux_kernel'
require 'hakiri/technologies/memcached'
require 'hakiri/technologies/mongodb'
require 'hakiri/technologies/mysql'
require 'hakiri/technologies/nginx'
require 'hakiri/technologies/phusion_passenger'
require 'hakiri/technologies/postgres'
require 'hakiri/technologies/redis'
require 'hakiri/technologies/ruby'
require 'hakiri/technologies/ruby_on_rails'
require 'hakiri/technologies/thin'
require 'hakiri/technologies/trinidad'
require 'hakiri/technologies/unicorn'