class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal
  
  validates_presence_of :user
  validates_presence_of :deal
end
