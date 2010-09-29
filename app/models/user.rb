class User < ActiveRecord::Base
  acts_as_authentic
  validates_numericality_of :budget, :greater_than => 0, :less_than => 1000000000, :allow_nil => true
  
  has_many :deals
  has_many :commitments
  
  def has_access_to? deal
    deal.user == self
  end
  
  def has_invested_in? deal
    commitments.each do |commitment| 
      return true if commitment.deal == deal
    end
    false
  end
end
