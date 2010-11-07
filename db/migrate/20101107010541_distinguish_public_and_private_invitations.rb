class DistinguishPublicAndPrivateInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :public, :boolean, :default => false
  end

  def self.down
    remove_column :invitations, :public
  end
end
