require 'json'

module CloudFlare
  class Zone < API
    def list_zones(options = {})
      uri = URI(root_url + 'zones')
      uri.query = URI.encode_www_form(options)
      make_request(uri) { Net::HTTP::Get.new(uri) }
    end

    def get_identifier(name)
      body = JSON.load(list_zones(name: name).body)
      abort 'Domain identifier not found' if body['result'].empty?
      body['result'].first['id']
    end
  end
end
