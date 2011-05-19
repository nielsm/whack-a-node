require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rack/test'

describe "WhackADnode" do
  include Rack::Test::Methods
  include WebMock::API
  class DwhackyTest < WhackADnode
    def rewrite_env(env)
      env['PORT'] = 90220
    end
  end
  
  def app
     WhackADnode.new
  end 

   it "should have a port of 90210" do
     stub_request(:get, "http://localhost:8810/").
       with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
     #@app.should_not be_nil
   end
end

