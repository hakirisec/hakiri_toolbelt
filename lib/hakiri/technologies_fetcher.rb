class Hakiri::TechnologiesFetcher
  def initialize
  end

  def fetch
    technologies = {}

    begin
      technologies[:ruby] = `ruby -v`
    rescue Exception => e
      technologies[:ruby] = 'Not Found'
    end

    begin
      technologies[:postgres] = `postgres -V`
    rescue Exception => e
      technologies[:postgres] = 'Not Found'
    end

    begin
      technologies[:java] = `java -version 2>&1 | awk 'NR == 2 { print ; }'`
    rescue Exception => e
      technologies[:java] = 'Not Found'
    end

    begin
      technologies[:apache] = `httpd -v 2>&1 | awk 'NR == 1 { print ; }'`
    rescue Exception => e
      technologies[:apache] = 'Not Found'
    end

    begin
      technologies[:memcached] = `memcached -h 2>&1 | awk 'NR == 1 { print ; }'`
    rescue Exception => e
      technologies[:memcached] = 'Not Found'
    end

    technologies
  end
end
