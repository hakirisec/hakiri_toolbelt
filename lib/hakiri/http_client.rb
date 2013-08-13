require 'rest_client'

class Hakiri::HttpClient
  attr_accessor :auth_token, :api_url

  #
  # Initializes an http client.
  #
  def initialize
    @auth_token = (ENV['HAKIRI_AUTH_TOKEN'] or nil)
    @api_url = 'http://0.0.0.0:5000/api/v1' or (ENV['HAKIRI_API_URL'] or 'https://www.hakiriup.com/api/v1')
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
    # { |response, request, result, &block|
    #  JSON.parse(.to_str, symbolize_names: true)
    # "!      Server Error: #{response.code}"
    RestClient.post "#{@api_url}/issues/scan.json?auth_token=#{@auth_token}", params do |response, request, result, &block|
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
  # @param [String] params
  #   Hash of technologies with versions converted to a string.
  #
  # @return [Hash]
  #   Returns a hash of differences between technologies.
  #
  def check_versions_diff(stack_id, params)
    RestClient.post "#{@api_url}/stacks/#{stack_id}/versions/diffs.json?auth_token=#{@auth_token}", params do |response, request, result, &block|
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
  # @param [String] params
  #   Hash of technologies with versions converted to a string.
  #
  # @return [Hash]
  #   Returns a hash of updated versions.
  #
  def sync_stack_versions(stack_id, params)
    RestClient.put "#{@api_url}/stacks/#{stack_id}.json?auth_token=#{@auth_token}", params do |response, request, result, &block|
      case response.code
        when 200
          JSON.parse(response.to_str, :symbolize_names => true)
        else
          { :errors => [response.code] }
      end
    end
  end
end