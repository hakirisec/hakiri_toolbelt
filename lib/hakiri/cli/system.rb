class Hakiri::System < Hakiri::Cli
  #
  # Walks the user through system scanning process.
  #
  def scan
    if File.exist? @options.manifest
      @stack.build_from_json_file(@options.manifest)
      @stack.fetch_versions

      # GETTING VERSIONS
      say '-----> Scanning system for software versions...'

      if @stack.technologies.empty?
        say '       No versions were found...'
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
      say '!      You have to create a manifest file with "hakiri manifest:generate"'
    end
  end

  #
  # Walks the user through the version syncing process.
  #
  def sync
    @stack.build_from_json_file(@options.manifest)
    @stack.fetch_versions

    if @http_client.auth_token
      # GETTING VERSIONS
      say '-----> Scanning system for software versions...'

      if @stack.technologies.empty?
        say '       No versions were found...'
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
                  say "       New technology detected: #{diff[:technology][:name]} #{diff[:system_version]}"
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

  #
  # Walks the user through manual technologies selection.
  #
  def steps
    say 'Hakiri Walkthrough will help you configure your @stack step by step and show '
    say 'you vulnerabilities at the end.'
    puts ' '
    say 'Step 1 of 5: Rails Server'
    say '1. Unicorn'
    say '2. Phusion Passenger'
    say '3. Thin'
    say '4. Trinidad'
    say '5. None of the above'

    server = ask('What do you use as your Rails server? (1, 2, 3, 4 or 5) ', Integer) { |q| q.in = 1..5 }
    puts ' '
    say 'Step 2 of 5: Secondary Server'
    say '1. Apache'
    say '2. nginx'
    say '3. Both'
    say '4. Neither'

    extra_server = ask('Do you use Apache or nginx? (1, 2, 3 or 4) ', Integer) { |q| q.in = 1..4 }
    puts ' '
    say 'Step 3 of 5: Database'
    say '1. MySQL'
    say '2. Postgres'
    say '3. MongoDB'
    say '4. None of the above'

    db = ask('What database do you use? (1, 2, 3 or 4) ', Integer) { |q| q.in = 1..4 }
    puts ' '
    redis = agree 'Step 4 of 5: do you use Redis? (yes or no) '
    puts ' '
    memcached = agree 'Step 5 of 5: do you use Memcached? (yes or no) '

    say '-----> Retrieving software versions versions on your system...'

    @stack.build_from_input(server, extra_server, db, redis, memcached)
    @stack.fetch_versions

    if @stack.technologies.empty?
      say '       No versions were found...'
    else
      @stack.technologies.each do |technology_slug, payload|
        say "       Found #{payload[:name]} #{payload[:version]}"
      end

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
  end
end