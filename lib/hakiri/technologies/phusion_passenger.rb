class Hakiri::PhusionPassenger < Hakiri::Technology
  def version
    begin
      output = `#{@path}passenger -v 2>&1 | awk 'NR == 1 { print ; }'`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end