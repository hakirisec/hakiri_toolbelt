class Hakiri::SystemSteps < Hakiri::Cli
  #
  # Walks the user through manual technologies selection.
  #
  def command
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
      say '-----> No versions were found...'
    else
      @stack.technologies.each do |technology_slug, payload|
        say "-----> Found #{payload[:name]} #{payload[:version]}"
      end

      say '-----> Searching for vulnerabilities...'
      params = ({ technologies: @stack.technologies }.to_param)
      response = @http_client.get_issues(params)

      if response[:errors]
        response[:errors].each do |error|
          say "!      Server Error: #{error}"
        end
      else
        authenticated = response[:meta][:authenticated]

        if response[:technologies].empty?
          say '-----> No vulnerabilities found. Keep it up!'
        else
          response[:technologies].each do |technology|
            unless technology[:issues_count] == 0
              say "-----> Found #{technology[:issues_count].to_i} #{'vulnerability'.pluralize if technology[:issues_count].to_i != 1} in #{technology[:name]} #{technology[:version]}"
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
end