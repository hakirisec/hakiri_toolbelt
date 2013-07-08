begin
  require "cane/rake_task"

  Cane::RakeTask.new
rescue LoadError
  warn "unable to load 'cane'"
end
