require 'rest_client'

class Hakiri::HttpClient
  attr_accessor :auth_token, :api_url

  #
  # Initializes an http client.
  #
  def initialize
    @auth_token = (ENV['HAKIRI_AUTH_TOKEN'] or nil)
    @api_url = (ENV['HAKIRI_API_URL'] or 'http://www.hakiriup.com/api/v1')
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
    JSON.parse(RestClient.get("#{@api_url}/issues.json?auth_token=#{@auth_token}&#{params}").to_str, symbolize_names: true)
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
  def check_versions_diff(params)
    JSON.parse(RestClient.get("#{@api_url}/versions/diffs.json?auth_token=#{@auth_token}&#{params}").to_str, symbolize_names: true)
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
  def sync_project_versions(project_id, params)
    JSON.parse(RestClient.put("#{@api_url}/projects/#{project_id}.json?auth_token=#{@auth_token}", params).to_str, symbolize_names: true)
  end
end