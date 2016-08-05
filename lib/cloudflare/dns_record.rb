require 'net/http'

module CloudFlare
  class DNSRecord < Zone
    attr_reader :dns_record, :zone_identifier, :zone_name, :record_name

    def load_record(zone_name, record_name)
      @zone_identifier = get_identifier(zone_name)
      @zone_name = zone_name
      @record_name = record_name
      uri = dns_uri(@zone_identifier)
      uri.query = URI.encode_www_form(type: 'A', name: "#{record_name}.#{zone_name}")
      resp = make_request(uri) { Net::HTTP::Get.new(uri) }
      body = JSON.load(resp.body)
      abort 'DNSRecord not found' if body['result'].empty?
      @dns_record = body
    end

    def update_ip(ip)
       uri = URI(root_url + "zones/#{zone_identifier}/dns_records/#{identifier}")
       resp = make_request(uri) do
         req = Net::HTTP::Put.new(uri)
         req.body = JSON.generate(id: identifier, content: ip, type: 'A',
                                  name: "#{record_name}.#{zone_name}",
                                  zone_name: zone_name, proxied: false)
         req
       end
       body = JSON.load(resp.body)
       abort 'DNSRecord could not be updated' if body.empty?
       body
    end

    def identifier
      dns_record['result'].first['id']
    end

    def ip_address
      dns_record['result'].first['content']
    end

    private

    def dns_uri(identifier)
      URI(root_url + "zones/#{identifier}/dns_records")
    end
  end
end
