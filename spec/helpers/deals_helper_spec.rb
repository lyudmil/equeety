describe DealsHelper do
  
  it "should provide status options" do
    status_options.should == ['new', 'pending', 'due_diligence', 'agreed', 'rejected']
  end
  
  it "should provide round options" do
    round_options.should == ['Pre-Seed', 'Seed', 'A', 'B', 'C']
  end
  
  describe "image path" do
    
    it "should be correct for a new deal" do
      deal = Deal.new(:status => 'new')
      
      status_image_for(deal).should == '/images/new.gif'
    end
    
    it "should be correct for a pending deal" do
      deal = Deal.new(:status => 'pending')
      
      status_image_for(deal).should == '/images/pending.gif'
    end
    
    it "should be correct for a due diligence deal" do
      deal = Deal.new(:status => 'due_diligence')
      
      status_image_for(deal).should == '/images/due_delegence.gif'
    end
    
    it "should be correct for an agreed deal" do
      deal = Deal.new(:status => 'agreed')
      
      status_image_for(deal).should == '/images/agreed.gif'
    end
    
    it "should be correct for a rejected deal" do
      deal = Deal.new(:status => 'rejected')
      
      status_image_for(deal).should == '/images/rejected.gif'
    end
  end
  
end