class Hakiri::Redis < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'Redis'
  end

  def version
    begin
      output = `#{@path}redis-server -v 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end