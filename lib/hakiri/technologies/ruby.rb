class Hakiri::Ruby < Hakiri::Technology
  def initialize(command = '')
    super

    @name = 'Ruby'
  end

  def version
    begin
      output = (@command.empty?) ? `ruby -v 2>&1` : `#{@command} 2>&1`
      /\d+(\.\d+)(\.\d+)(p\d+)/.match(output)[0].gsub('p', '.')
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end