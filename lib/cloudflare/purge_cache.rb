require 'json'

module CloudFlare
  class PurgeCache < Zone
    def purge_everything(name)
      identifier = get_identifier(name)
      uri = purge_uri(identifier)
      make_request(uri) do
        req = Net::HTTP::Delete.new(uri)
        req.body = JSON.generate(purge_everything: true)
        req
      end
    end

    private

    def purge_uri(identifier)
      URI(root_url + "zones/#{identifier}/purge_cache")
    end
  end
end
