class Hakiri::ApacheTomcat < Hakiri::Technology
  def initialize(command = '')
    super

    @name = 'Apache Tomcat'
  end

  def version
    begin
      output = (@command.empty?) ? `trinidad -v 2>&1` : `#{@command} 2>&1`
      /\d+(\.\d+)?(\.\d+)?\)/.match(output)[0].gsub(/\)/, '')
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end