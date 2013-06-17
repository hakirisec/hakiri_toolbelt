class Hakiri::HttpClient
  attr_accessor :auth_token, :api_url

  def initialize
    @auth_token = (ENV['HAKIRI_AUTH_TOKEN'] or nil)
    @api_url = 'http://0.0.0.0:3000/api/v1'
  end

  def get_issues(params)
    JSON.parse(URI.parse("#{@api_url}/issues.json?auth_token=#{@auth_token}&#{params}").read, symbolize_names: true)
  end

  def should_sync_versions(params)
    JSON.parse(URI.parse("#{@api_url}/technologies.json?auth_token=#{@auth_token}&#{params}").read, symbolize_names: true)
  end
end