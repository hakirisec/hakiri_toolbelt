class Hakiri::Technology

  # This method initialized Hakiri::Technology class
  #
  def initialize(path = '')
    @default_regexp = /\d+(\.\d+)(\.\d+)/
    @path = path
  end

  # This method outputs a default error in the command line.
  #
  # * *Args*    :
  #   - +e+ -> Supplied exception.
  #   - +output+ -> Output that triggered the error.
  #
  def puts_error(e, output)
    puts "Error: #{output.lines.first}"
  end
end