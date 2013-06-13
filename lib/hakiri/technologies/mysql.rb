class Hakiri::Mysql < Hakiri::Technology
  def version
    begin
      output = `#{@path}mysql -version 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end
end