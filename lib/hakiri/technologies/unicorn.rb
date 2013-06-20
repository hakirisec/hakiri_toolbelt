class Hakiri::Unicorn < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'Unicorn'
  end

  def version
    begin
      output = `#{@path}unicorn -v 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end