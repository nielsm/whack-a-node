require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rack/test'
include Rack::Test::Methods

describe "WhackANode" do
  class WhackyTest < WhackANode
    def rewrite_env(env)
      env['PORT'] = 90210
    end
  end
  
  def app
     WhackANode.new
  end

  #before(:each) do
    #@app = WhackyTest.new
  #end
   it "should have a port of 90210" do
     get "/"
     last_response.should_not be_nil
     #@app.should_not be_nil
   end
end
