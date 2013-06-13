class Hakiri::Ruby < Hakiri::Technology
  def version
    begin
      output = `#{@path}ruby -v 2>&1`
      /\d+(\.\d+)(\.\d+)(p\d+)/.match(output)[0].gsub('p', '.')
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end