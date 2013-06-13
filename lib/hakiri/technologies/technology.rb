class Hakiri::Technology
  def initialize(path = '')
    @default_regexp = /\d+(\.\d+)(\.\d+)/
    @path = path
  end

  def version
    nil
  end

  def puts_error(e, output)
    puts "Error: #{output.lines.first}"
  end
end