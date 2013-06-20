class Hakiri::Cli
  def initialize(args, options)
    @args = args
    @options = options
    @http_client = Hakiri::HttpClient.new
    @stack = Hakiri::Stack.new()
  end
end