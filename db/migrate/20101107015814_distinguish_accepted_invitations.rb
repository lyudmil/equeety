class DistinguishAcceptedInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :accepted, :boolean, :default => false
  end

  def self.down
    remove_column :invitations, :accepted
  end
end
