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

  #
  # Walks the user through Gemfile syncing process.
  #
  def sync
    if @http_client.auth_token
      @stack.build_from_gemfile(@options.gemfile)

      # GETTING VERSIONS

      if @stack.technologies.empty?
        say '       No gems were found in your Gemfile.lock...'
      else
        @stack.technologies.each do |technology_name, payload|
          say "       Found #{payload[:name]} #{payload[:version]}"
        end

        # CHECK VERSIONS ON THE SERVER
        params = { :project_id => @options.project, :technologies => @stack.technologies }
        say '-----> Checking software versions on www.hakiriup.com...'
        response = @http_client.check_versions_diff(params)

        if response[:errors]
          response[:errors].each do |error|
            say "!      Server Error: #{error}"
          end
        else
          if response[:diffs].any?
            @stack.technologies = {}
            response[:diffs].each do |diff|
              if diff[:success]
                @stack.technologies[diff[:technology][:slug]] = { :version => diff[:system_version] }

                if diff[:hakiri_version]
                  if diff[:system_version_newer]
                    say "       System version of #{diff[:technology][:name]} is newer (#{diff[:system_version]} > #{diff[:hakiri_version]})"
                  else
                    say "       System version of #{diff[:technology][:name]} is older (#{diff[:system_version]} < #{diff[:hakiri_version]})"
                  end
                else
                  say "       New gem detected: #{diff[:technology][:name]} #{diff[:system_version]}"
                end
              else
                say "!      Error in #{diff[:technology][:name]}: #{diff[:errors][:value][0]}"
              end
            end

            # UPDATE VERSIONS ON THE SERVER
            unless @options.force
              update = agree "Do you want to update \"#{response[:project][:name]}\" with system versions? (yes or no) "
            end

            if update or @options.force
              say '-----> Syncing versions with www.hakiriup.com...'
              params = ({ :project_id => @options.project, :technologies => @stack.technologies }.to_param)
              response = @http_client.sync_project_versions(response[:project][:id], params)

              if response[:errors]
                response[:errors].each do |error|
                  say "!      Server Error: #{error}"
                end
              else
                if response[:updated].any?
                  response[:updated].each do |update|
                    if update[:success]
                      say "       #{update[:technology][:name]} was updated to #{update[:new_version]}"
                    else
                      say "!      Error syncing #{update[:technology][:name]}: #{update[:errors][:value][0]}"
                    end
                  end
                end
              end
            end
          else
            say '       No differences were found. Everything is up to date.'
          end
        end
      end
    else
      say '!      You have to setup HAKIRI_AUTH_TOKEN environmental variable with your Hakiri authentication token.'
    end
  end
end