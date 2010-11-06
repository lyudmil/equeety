require "spec_helper"

describe OffersController do
  describe "routing" do
    it "recognizes new offer urls" do
      { :get => "/offers/lyudmil" }.should route_to(:controller => "offers", :action => "new", :nickname => "lyudmil")
    end
  end
end
