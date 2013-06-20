class Hakiri::Jruby < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'JRuby'
  end

  def version
    begin
      output = `#{@path}jruby -v 2>&1 | awk 'NR == 2 { print ; }'`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end