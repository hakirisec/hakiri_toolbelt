begin
  require "simplecov"
  SimpleCov.start do
    add_filter "test"
    command_name "Minitest"
  end
rescue LoadError
  warn "unable to load 'simplecov'"
end

require "minitest/autorun"
require "minitest/pride"

require File.expand_path("../../lib/hakiri", __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in test/support/ and its subdirectories.
Dir[File.join("./test/support/**/*.rb")].sort.each { |f| require f }
