require 'spec_helper'

describe StaticPagesController do
  
  describe "home" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

end
