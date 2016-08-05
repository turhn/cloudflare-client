module CloudFlare
  class API
    API_VERSION = 4

    def initialize(api_key, email)
      @api_key = api_key
      @email   = email
    end

    def root_url
      "https://api.cloudflare.com/client/v#{API_VERSION}/"
    end

    def make_request(uri)
      req = yield
      decorate_request(req)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
    end

    private

    def decorate_request(req)
      req['X-Auth-Key']   = @api_key
      req['X-Auth-Email'] = @email
      req['Content-Type'] = 'application/json'
    end
  end
end
