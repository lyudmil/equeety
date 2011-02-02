class AddStatusToDeals < ActiveRecord::Migration
  def self.up
    add_column :deals, :status, :string
  end

  def self.down
    remove_column :deals, :status
  end
end
