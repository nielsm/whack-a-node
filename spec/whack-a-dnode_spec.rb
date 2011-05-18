require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rack/test'
include Rack::Test::Methods

describe "WhackADnode" do
  class DwhackyTest < WhackADnode
    def rewrite_env(env)
      env['PORT'] = 90220
    end
  end
  
  def app
     WhackADnode.new
  end 

  #before(:each) do
    #@app = WhackyTest.new
  #end
   it "should have a port of 90220" do
     get "/"
     last_response.should_not be_nil
     #@app.should_not be_nil
   end
end

