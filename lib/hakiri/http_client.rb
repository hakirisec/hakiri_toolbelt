require 'rest_client'

class Hakiri::HttpClient
  attr_accessor :auth_token, :api_url

  #
  # Initializes an http client.
  #
  def initialize
    @auth_token = (ENV['HAKIRI_AUTH_TOKEN'] or nil)
    @api_url = (ENV['HAKIRI_API_URL'] or 'https://www.hakiriup.com/api/v1')
  end

  #
  # Gets vulnerabilities from the server based on the supplied versions.
  #
  # @param [String] params
  #   Hash of technologies with versions converted to a string.
  #
  # @return [Hash]
  #   Returns a hash of technologies with vulnerabilities.
  #
  def get_issues(params)
    params[:auth_token] = @auth_token

    RestClient.post "#{@api_url}/issues/scan.json", params do |response, request, result, &block|
      case response.code
        when 200
          JSON.parse(response.to_str, :symbolize_names => true)
        else
          { :errors => [response.code] }
      end
    end
  end

  #
  # Checks system and server version differences.
  #
  # @param [Integer] stack_id
  #   Stack ID.
  #
  # @param [String] params
  #   Hash of technologies with versions converted to a string.
  #
  # @return [Hash]
  #   Returns a hash of differences between technologies.
  #
  def check_versions_diff(stack_id, params)
    params[:auth_token] = @auth_token

    RestClient.post "#{@api_url}/stacks/#{stack_id}/versions/diffs.json", params do |response, request, result, &block|
      case response.code
        when 200
          JSON.parse(response.to_str, :symbolize_names => true)
        else
          { :errors => [response.code] }
      end
    end
  end

  #
  # Syncs system and server versions.
  #
  # @param [Integer] stack_id
  #   Stack ID.
  #
  # @param [String] params
  #   Hash of technologies with versions converted to a string.
  #
  # @return [Hash]
  #   Returns a hash of updated versions.
  #
  def sync_stack_versions(stack_id, params)
    params[:auth_token] = @auth_token

    RestClient.put "#{@api_url}/stacks/#{stack_id}/versions/update_all.json", params do |response, request, result, &block|
      case response.code
        when 200
          JSON.parse(response.to_str, :symbolize_names => true)
        else
          { :errors => [response.code] }
      end
    end
  end

  #
  # Gets latest build data.
  #
  # @param [Integer] stack_id
  #   Stack ID.
  #
  # @return [Hash]
  #   Returns a hash with build fields, repository fields and an array of warnings.
  #
  def code_report(stack_id)
    RestClient.get "#{@api_url}/stacks/#{stack_id}/builds/last.json?auth_token=#{@auth_token}" do |response, request, result, &block|
      case response.code
        when 200
          JSON.parse(response.to_str, :symbolize_names => true)
        else
          { :errors => [response.code] }
      end
    end
  end
end