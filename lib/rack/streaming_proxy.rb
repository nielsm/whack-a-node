module Rack
  class StreamingProxy

    # The block provided to the initializer is given a Rack::Request
    # and should return:
    #
    #   * nil/false to skip the proxy and continue down the stack
    #   * a complete uri (with query string if applicable) to proxy to
    #
    # E.g.
    #
    #   use Rack::StreamingProxy do |req|
    #     if req.path.start_with?("/search")
    #       "http://some_other_service/search?#{req.query}"
    #     end
    #   end
    #
    # Most headers, request body, and HTTP method are preserved.
    #
    def initialize(app, &block)
      @request_uri = block
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      return app.call(env) unless uri = request_uri.call(req)
      begin # only want to catch proxy errors, not app errors
        proxy = ProxyRequest.new(req, uri)
        [proxy.status, proxy.headers, proxy]
      rescue => e
        msg = "Proxy error when proxying to #{uri}: #{e.class}: #{e.message}"
        env["rack.errors"].puts msg
        env["rack.errors"].puts e.backtrace.map { |l| "\t" + l }
        env["rack.errors"].flush
        raise Error, msg
      end
    end

    protected

    attr_reader :request_uri, :app

  end

end


