class Hakiri::Apache < Hakiri::Technology
  def initialize(command = '')
    super

    @name = 'Apache'
  end

  def version
    begin
      output = (@command.empty?) ? `httpd -v 2>&1 | awk 'NR == 1 { print ; }'` : `#{@command} 2>&1 | awk 'NR == 1 { print ; }'`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end