class Hakiri::Mongodb < Hakiri::Technology
  def version
    begin
      output = `ps -ax | grep mongo 2>&1`
      @default_regexp.match(output)[0]
    rescue Exception => e
      puts_error(e, output)
      nil
    end
  end

  def puts_error(e, output)
    puts "Error: couldn't find a running version of MongoDB"
  end
end