class Hakiri::Gemfile < Hakiri::Cli
  #
  # Walks the user through Gemfile scanning process.
  #
  def scan
    if File.exist? @options.gemfile
      @stack.build_from_gemfile(@options.gemfile)

      if @stack.technologies.empty?
        say '       No gems were found in your Gemfile.lock...'
      else
        @stack.technologies.each do |technology_slug, payload|
          say "       Found #{payload[:name]} #{payload[:version]}"
        end

        # GETTING VULNERABILITIES
        say '-----> Searching for vulnerabilities...'
        params = ({ :technologies => @stack.technologies }.to_param)
        response = @http_client.get_issues(params)

        if response[:errors]
          response[:errors].each do |error|
            say "!      Server Error: #{error}"
          end
        else
          authenticated = response[:meta][:authenticated]

          if response[:technologies].empty?
            say '       No vulnerabilities found. Keep it up!'
          else
            response[:technologies].each do |technology|
              unless technology[:issues_count] == 0
                say "!      Found #{technology[:issues_count].to_i} #{'vulnerability'.pluralize if technology[:issues_count].to_i != 1} in #{technology[:name]} #{technology[:version]}"
              end
            end

            if agree 'Show all of them? (yes or no) '
              puts ' '
              response[:technologies].each do |technology|
                technology[:issues].each do |issue|
                  say issue[:name]
                  say issue[:description]
                  puts ' '
                end
              end
            end

            unless authenticated
              say '****** Signup on www.hakiriup.com to get notified when new vulnerabilities come out.'
            end
          end
        end
      end
    else
      say '!      You have to either have a Gemfile.lock in the current directory or setup a parameter `-p` with a path to it.'
    end
  end
end