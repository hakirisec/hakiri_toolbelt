class Hakiri::LinuxKernel < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'Linux Kernel'
  end

  def version
    begin
      output = `#{@path}uname -r  2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end