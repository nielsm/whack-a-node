require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rack/test'
include Rack::Test::Methods

describe "WhackANode" do
  class WhackyTest < WhackANode
    def rewrite_env(env)
      env['PORT'] = 90210
    end
  end
  
  before(:each) do
    @app = WhackyTest.new
  end
   it "should have a port of 90210" do
     @app.get "/"
     response.should_not be_nil
     @app.should_not be_nil
   end
  it "fails" do
    fail "hey buddy, you should probably rename this file and start specing for real"
  end
end
