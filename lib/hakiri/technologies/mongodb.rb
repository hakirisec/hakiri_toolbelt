class Hakiri::Mongodb < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'MongoDB'
  end

  def version
    begin
      output = `ps -ax | grep mongo 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end

  def puts_error(e, output)
    say '!      Can\'t find MongoDB'
  end
end