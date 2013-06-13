class Hakiri::Trinidad < Hakiri::Technology
  def version
    begin
      output = `#{@path}trinidad -v 2>&1 | awk 'NR == 2 { print ; }'`
      puts output
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end