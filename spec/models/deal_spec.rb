require 'spec_helper'

describe Deal do
  it "should belong to a user" do
    user = mock_model('User')
    deal = Deal.new(:user => user)
    deal.user.should == user
  end
end
