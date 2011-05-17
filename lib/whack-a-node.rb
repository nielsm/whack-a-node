require 'rack/streaming_proxy'
class WhackANode < Rack::StreamingProxy

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
