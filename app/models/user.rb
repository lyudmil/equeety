class User < ActiveRecord::Base
  include Gravtastic
  
  has_gravatar
  acts_as_authentic
  validates_numericality_of :budget, :greater_than => 0, :less_than => 1000000000, :allow_nil => true
  validates_uniqueness_of :nickname, :allow_blank => true, :case_sensitive => false
  
  has_many :deals
  has_many :commitments
  has_many :invitations
  
  def has_access_to? deal
    owns? deal or invitations.any? { |invite| invite.deal == deal }
  end
  
  def has_invested_in? deal
    commitments.any? { |commitment| commitment.deal == deal }
  end
  
  def owns? deal
    deal.user == self
  end
  
  def committed_budget
    committed_budget = 0
    commitments.each { |commitment| committed_budget += commitment.amount }
    committed_budget
  end
  
  def remaining_budget
    return -committed_budget unless budget
    budget - committed_budget
  end
end
