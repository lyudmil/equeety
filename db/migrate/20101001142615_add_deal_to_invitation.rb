class AddDealToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :deal_id, :integer
  end

  def self.down
    remove_column :invitations, :deal_id
  end
end
