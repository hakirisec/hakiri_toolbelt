class Hakiri::Technology
  attr_accessor :name

  def initialize(path = '')
    @default_regexp = /\d+(\.\d+)(\.\d+)/
    @path = path
    @name = 'Technology'
  end

  def puts_error(e, output)
    puts "!     Can't find #{self.class.name.demodulize}: #{output.lines.first}"
  end
end