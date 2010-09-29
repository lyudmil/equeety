class Commitment < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal
  
  validates_numericality_of :amount, :greater_than => 0, :less_than => 1000000000
end
