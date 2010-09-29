class AddCommitmentsToDeals < ActiveRecord::Migration
  def self.up
    add_column :commitments, :deal_id, :integer
  end

  def self.down
    remove_column :commitments, :deal_id
  end
end
