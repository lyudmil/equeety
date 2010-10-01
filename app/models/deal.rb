class Deal < ActiveRecord::Base
  belongs_to :user
  has_many :commitments
  has_many :invitations
  
  validates_presence_of :startup_name, :website, :contact_name
  validates_numericality_of :required_amount, :greater_than => 0, :less_than => 10000000
  validates_numericality_of :proposed_valuation, :greater_than => 0, :less_than => 1000000000
  validates_format_of :contact_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  URL_FORMAT = /^(https?\:\/\/)?([\w\d\-_]+(\.[\d\w\-_]+)*)(\/|$)/i
  validates_format_of :website, :with => URL_FORMAT, :if => :website?
  validates_format_of :logo_url, :with => URL_FORMAT, :if => :logo_url?
end
