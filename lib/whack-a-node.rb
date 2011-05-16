require 'rack/proxy'
class WhackANode < Rack::Proxy

  def rewrite_env(env)
    env["PORT"] = "8810"

    env
  end

  def rewrite_response(triplet)
    status, headers, body = triplet

    headers["X-Foo"] = "Bar"

    triplet
  end

end