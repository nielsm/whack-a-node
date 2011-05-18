require 'dnode'
require 'eventmachine'
require 'events'
class WhackADnode
  def initialize(path, host="localhost", port="8820", redirect=false)
    @path = path
    @host = host
    @port = port
    @redirect = redirect
    @dnode = DNode.new({
      :f => proc { |x,cb| cb.call(x) }
    }).listen(@port)

  end
  
  def proxy_request
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

  def forward_request
    [ 302, {'Location'=> uri.to_s }, [] ]
  end
  
  def call(env)
    return @redirect ? forward_request : proxy_request
  end
  
    private


    def get_matcher_and_url path
      matches = @paths.select do |matcher, url|
        match_path(path, matcher)
      end

      if matches.length < 1
        nil
      elsif matches.length > 1
        raise AmbiguousProxyMatch.new(path, matches)
      else
        matches.first.map{|a| a.dup}
      end
    end

    def create_response_headers http_response
      response_headers = Rack::Utils::HeaderHash.new(http_response.to_hash)
      # handled by Rack
      response_headers.delete('status')
      # TODO: figure out how to handle chunked responses
      response_headers.delete('transfer-encoding')
      # TODO: Verify Content Length, and required Rack headers
      response_headers
    end

    def match_path(path, matcher)
      if matcher.is_a?(Regexp)
        path.match(matcher)
      else
        path.match(/^#{matcher.to_s}/)
      end
    end

    def get_uri(url, matcher, path)
      if url =~/\$\d/
        match_path(path, matcher).to_a.each_with_index { |m, i| url.gsub!("$#{i.to_s}", m) }
        URI(url)
      else
        URI.join(url, path)
      end
    end

    def reverse_proxy matcher, url, opts={}
      raise GenericProxyURI.new(url) if matcher.is_a?(String) && URI(url).class == URI::Generic
      @paths.merge!(matcher => url)
      @opts.merge!(opts)
    end
  

  def rewrite_env(env)
    env["PORT"] = "8000"

    env
  end

  def rewrite_response(triplet)
    status, headers, body = triplet

    headers["X-Foo"] = "Bar"

    triplet
  end

end
