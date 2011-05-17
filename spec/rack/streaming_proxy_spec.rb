require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rack::StreamingProxy do
  include Rack::Test::Methods
  include WebMock::API

  def app 
    Rack::StreamingProxy.new
  end

  it "should have a port of 90210" do
     get "/"
     last_response.should_not be_nil
     #@app.should_not be_nil
   end
end
