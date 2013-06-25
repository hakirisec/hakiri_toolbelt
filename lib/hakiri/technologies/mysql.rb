class Hakiri::Mysql < Hakiri::Technology
  def initialize(command = '')
    super

    @name = 'MySQL'
  end

  def version
    begin
      output = (@command.empty?) ? `mysql -version 2>&1` : `#{@command} 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end