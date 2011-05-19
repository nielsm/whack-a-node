module WhackANode
  class Redirect
    include WhackANode::Whacky
    
    def call(env)
      [ 302, {'Location'=> uri.to_s }, [] ]
    end

  end
end