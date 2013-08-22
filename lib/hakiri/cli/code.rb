class Hakiri::Code < Hakiri::Cli
  #
  # Walks the user through code report process.
  #
  def report
    if @http_client.auth_token
      say '-----> Loading code report...'
      response = @http_client.code_report(@options.stack)

      if response[:errors]
        response[:errors].each do |error|
          say "!      Server Error: #{error}"
        end
      else
        say "       Repo: #{response[:repository][:name]}"
        say "       Branch: #{response[:repository][:branch]}"
        say "       Latest commit: #{response[:last_commit_id]}"

        if response[:warnings_count] == 0
          say '       No warnings were found in your code. Keep it up!'
        else
          say "!      #{response[:warnings_count]} warnings were found in your code."

          if agree 'Show all of them? (yes or no) '
            puts ' '
            response[:warnings].each do |warning|
              say "#{warning[:warning_type]}: #{warning[:message]}"
              puts ' '
            end
          end
        end
      end
    else
      say '!      You have to setup HAKIRI_AUTH_TOKEN environmental variable with your Hakiri authentication token.'
    end
  end
end