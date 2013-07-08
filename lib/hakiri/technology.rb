class Hakiri::Technology
  attr_accessor :name
  #
  # Initializes a technology.
  #
  def initialize(command = '')
    @default_regexp = /\d+\.\d+\.\d+/
    @command = command
    @name = 'Technology'
  end

  #
  # Prints an error if can't find version
  #
  # @param [Exception] e
  #   Exception returned by Ruby.
  #
  # @param [String] output
  #   System output from attempted version query.
  #
  def puts_error(e, output)
    say "!      Can't find #{name}: #{output.lines.first}"
  end
end