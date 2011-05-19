require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rack/test'

describe "WhackANode::Proxy" do
  include Rack::Test::Methods
  include WebMock::API
  class WhackyTest < WhackANode::Proxy
    def rewrite_env(env)
      env['PORT'] = 90210
    end
  end
  
  def app
     WhackANode::Proxy.new
  end

  #before(:each) do
    #@app = WhackyTest.new
  #end
   it "should have a port of 90210" do
      stub_request(:get, "http://localhost:8810/").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
     
     #stub_request(:get, 'http://example.com/').to_return({:body => "Proxied App"})
     #get '/'
     #last_response.should_not be_nil
     #@app.should_not be_nil
   end
end
