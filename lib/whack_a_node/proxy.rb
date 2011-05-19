require 'net/http'
module WhackANode
  class Proxy
    include WhackANode::Whacky
    
    def call(env)
      uri = self.uri
      session = Net::HTTP.new(uri.host, uri.port)
      session.start {|http|
        req = Net::HTTP::Get.new(uri.request_uri)
        body = ''
        res = http.request(req) do |res|
          res.read_body do |segment|
            body << segment
          end
        end
        [res.code, create_response_headers(res), [body]]
        }
    end
    
    private
    
    def create_response_headers http_response
      response_headers = Rack::Utils::HeaderHash.new(http_response.to_hash)
      # handled by Rack
      response_headers.delete('status')
      # TODO: figure out how to handle chunked responses
      response_headers.delete('transfer-encoding')
      # TODO: Verify Content Length, and required Rack headers
      response_headers
    end
  end
end