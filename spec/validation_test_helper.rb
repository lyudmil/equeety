module ValidationTestHelper
  def validation_sanity_check
     deal = model_class.new(valid_fields)
     deal.should be_valid
  end
  
  def assert_validates_numericality_of field
    deal = model_class.new(valid_fields.except(field))
    deal.should_not be_valid
    deal.errors_on(field).should == ["is not a number"]
    
    validation_sanity_check
  end
  
  def assert_validates_positiveness_of field
    model = model_class.new(valid_fields.except(field).merge({field => 0}))
    model.should_not be_valid
    model.errors_on(field).should == ["must be greater than 0"]
    
    validation_sanity_check
  end
  
  def assert_validates_presence_of field
    model = model_class.new(valid_fields.except(field))
    model.should_not be_valid
    model.errors_on(field).should == ["can't be blank"]
    
    validation_sanity_check
  end
  
  def assert_validates_upper_bound_of field, upper_bound
    model = model_class.new(valid_fields.except(field).merge({field => upper_bound}))
    model.should_not be_valid
    model.errors_on(field).should == ["must be less than #{upper_bound}"]
    
    validation_sanity_check
  end
end