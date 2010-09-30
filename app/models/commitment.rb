require 'user_budget_validator'

class Commitment < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal
  
  validates_numericality_of :amount, :greater_than => 0, :less_than => 1000000000
  validates_uniqueness_of :user_id, :scope => :deal_id, :message => "You can only invest in a deal once."
  validates_with UserBudgetValidator
end
