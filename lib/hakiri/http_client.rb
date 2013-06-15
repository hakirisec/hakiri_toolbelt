class Hakiri::HttpClient
  def initialize
    @auth_token = (ENV['HAKIRI_AUTH_TOKEN'] or '')
  end

  def get_issues(params)
    JSON.parse(URI.parse("http://0.0.0.0:3000/api/v1/issues.json?auth_token=#{@auth_token}&#{params}").read, symbolize_names: true)
  end
end