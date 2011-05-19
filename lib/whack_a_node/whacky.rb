module WhackANode
  module Whacky
    def initialize(path,host="localhost", port="8810")
      @path = path
      @host = host
      @port = port
    end
    
    def uri
      URI("http://#{@host}:#{@port}#{@path}")
    end
  end
end