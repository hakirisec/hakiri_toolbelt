class Hakiri::RubyOnRails < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'Ruby on Rails'
  end

  def version
    begin
      output = `#{@path}rails -v 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end