module ValidationTestHelper
  def validation_sanity_check
     instance = model.new(valid_fields)
     instance.should be_valid
  end
  
  def assert_validates_numericality_of field
    instance = model.new(valid_fields.except(field))
    instance.should_not be_valid
    instance.errors_on(field).should == ["is not a number"]
    
    validation_sanity_check
  end
  
  def assert_validates_positiveness_of field
    instance = model.new(valid_fields.except(field).merge({field => 0}))
    instance.should_not be_valid
    instance.errors_on(field).should == ["must be greater than 0"]
    
    validation_sanity_check
  end
  
  def assert_validates_presence_of field
    instance = model.new(valid_fields.except(field))
    instance.should_not be_valid
    instance.errors_on(field).should == ["can't be blank"]
    
    validation_sanity_check
  end
  
  def assert_validates_upper_bound_of field, upper_bound
    instance = model.new(valid_fields.except(field).merge({field => upper_bound}))
    instance.should_not be_valid
    instance.errors_on(field).should == ["must be less than #{upper_bound}"]
    
    validation_sanity_check
  end
end