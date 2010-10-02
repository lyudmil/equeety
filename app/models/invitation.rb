class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :deal
  
  validates_presence_of :user
  validates_presence_of :deal
  validates_uniqueness_of :user_id, :scope => :deal_id, :message => "already knows about this deal."
end
