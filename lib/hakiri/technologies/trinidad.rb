class Hakiri::Trinidad < Hakiri::Technology
  def initialize(command = '')
    super

    @name = 'Trinidad'
  end

  def version
    begin
      output = (@command.empty?) ? `trinidad -v 2>&1 | awk 'NR == 2 { print ; }'` : `#{@command} 2>&1 | awk 'NR == 2 { print ; }'`
      puts output
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end