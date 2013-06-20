class Hakiri::Java < Hakiri::Technology
  def initialize(path = '')
    super

    @name = 'Java'
  end

  def version
    begin
      output = `#{@path}java -version 2>&1 | awk 'NR == 2 { print ; }'`
      /\d+(\.\d+)?(\.\d+)?(_\d+)?/.match(output)[0].gsub('_', '.')
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end