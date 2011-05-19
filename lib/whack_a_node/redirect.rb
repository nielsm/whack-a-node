module WhackANode
  class Redirect
    
    def initialize(path="/",host="localhost", port="8810")
      @path = path
      @host = host
      @port = port
    end
    
    def call(env)
      [ 302, {'Location'=> uri.to_s }, [] ]
    end
    
    def uri
      URI("http://#{@host}:#{@port}#{@path}")
    end
    
  end
end