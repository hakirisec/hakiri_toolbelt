class Hakiri::SystemSteps < Hakiri::Cli
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

    @stack = Hakiri::@stack.new()
    @stack.build_from_input(server, extra_server, db, redis, memcached)
    @stack.fetch_versions

    if @stack.technologies.empty?
      say '-----> No versions were found...'
    else
      @stack.technologies.each do |technology_name, payload|
        say "-----> Found #{technology_name} #{payload[:version]}"
      end
    end
  end
end