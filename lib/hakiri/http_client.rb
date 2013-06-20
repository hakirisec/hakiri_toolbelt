require 'rest_client'

class Hakiri::HttpClient
  attr_accessor :auth_token, :api_url

  def initialize
    @auth_token = (ENV['HAKIRI_AUTH_TOKEN'] or nil)
    @api_url = 'http://0.0.0.0:5000/api/v1'
  end

  def get_issues(params)
    JSON.parse(RestClient.get("#{@api_url}/issues.json?auth_token=#{@auth_token}&#{params}").to_str, symbolize_names: true)
  end

  def check_versions_diff(params)
    JSON.parse(RestClient.get("#{@api_url}/versions/diffs.json?auth_token=#{@auth_token}&#{params}").to_str, symbolize_names: true)
  end

  def sync_project_versions(project_id, params)
    JSON.parse(RestClient.put("#{@api_url}/projects/#{project_id}.json?auth_token=#{@auth_token}", params).to_str, symbolize_names: true)
  end
end