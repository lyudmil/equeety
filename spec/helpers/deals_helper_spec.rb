describe DealsHelper do
  
  it "should provide status options" do
    status_options.should == ['new', 'pending', 'due_diligence', 'agreed', 'rejected']
  end
  
  it "should provide round options" do
    round_options.should == ['Pre-Seed', 'Seed', 'A', 'B', 'C']
  end
  
end