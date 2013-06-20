class Hakiri::SystemScan < Hakiri::Cli
  def command
    @stack.build_from_json_file(@options.stack)
    @stack.fetch_versions
    
    # GETTING VERSIONS
    say '-----> Scanning system for software versions...'

    if @stack.technologies.empty?
      say '-----> No versions were found...'
    else
      @stack.technologies.each do |technology_name, payload|
        say "-----> Found #{technology_name} #{payload[:version]}"
      end

      # GETTING VULNERABILITIES
      say '-----> Searching for vulnerabilities...'
      params = ({ technologies: @stack.technologies }.to_param)
      response = @http_client.get_issues(params)
      authenticated = response[:meta][:authenticated]

      if response[:technologies].empty?
        say '-----> No vulnerabilities found. Keep it up!'
      else
        response[:technologies].each do |technology|
          unless technology[:issues_count] == 0
            say "-----> Found #{technology[:issues_count].to_i} #{'vulnerability'.pluralize if technology[:issues_count].to_i != 1} in #{technology[:technology][:name]} #{technology[:version]}"
            puts ' '
          end
        end

        if authenticated
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
        else
          say '****** Signup on www.hakiriup.com and make your command line requests with an auth_token, so you can see issues that your technologies have.'
          say '****** You will also receive notifications via email whenever new issues are found.'
        end
      end
    end
  end
end