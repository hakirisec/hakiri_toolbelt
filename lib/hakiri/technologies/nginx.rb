class Hakiri::Nginx < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'nginx'
  end

  def version
    begin
      output = `#{@path}nginx -v 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end