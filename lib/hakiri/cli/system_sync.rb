class Hakiri::SystemSync < Hakiri::Cli
  def command
    @stack.build_from_json_file(@options.stack)
    @stack.fetch_versions

    if @http_client.auth_token
      # GETTING VERSIONS
      say '-----> Scanning system for software versions...'

      if @stack.technologies.empty?
        say '-----> No versions were found...'
      else
        @stack.technologies.each do |technology_name, payload|
          say "-----> Found #{technology_name} #{payload[:version]}"
        end

        # CHECK VERSIONS ON THE SERVER
        params = ({ project_id: @options.project, technologies: @stack.technologies }.to_param)
        say '-----> Checking software versions on www.hakiriup.com...'
        response = @http_client.check_versions_diff(params)

        if response[:diffs].any?
          @stack.technologies = {}
          response[:diffs].each do |diff|
            if diff[:success]
              if diff[:hakiri_version]
                @stack.technologies[diff[:technology][:slug]] = { version: diff[:system_version] }
                say "-----> System version of #{diff[:technology][:name]} is newer (#{diff[:system_version]} > #{diff[:hakiri_version]})"
              else
                say "-----> New technology detected: #{diff[:technology][:name]} #{diff[:system_version]}"
              end
            else
              say "!      Error in #{diff[:technology][:name]}: #{diff[:errors][:value][0]}"
            end
          end

          if @stack.technologies.any?
            update = agree "Do you want to update \"#{response[:project][:name]}\" with new versions? (yes or no) "
          else
            say '-----> Nothing to update.'
          end

          if update
            params = ({ project_id: @options.project, technologies: @stack.technologies }.to_param)
            response = @http_client.sync_project_versions(response[:project][:id], params)
            p response
            if response[:updated].any?
              response[:updated].each do |update|
                if update[:success]
                  say "-----> #{update[:technology][:name]} was updated to #{update[:new_version]}"
                else
                  say "!      Error syncing #{update[:technology][:name]}: #{update[:errors][:value][0]}"
                end
              end
            end
          end
        else
          say '-----> No differences were found. Everything is up to date.'
        end

        # UPDATE VERSIONS ON THE SERVER
      end
    else
      say '!      You have to setup HAKIRI_AUTH_TOKEN environmental variable with your Hakiri authentication token.'
    end
  end
end