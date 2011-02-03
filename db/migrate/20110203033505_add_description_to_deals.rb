class AddDescriptionToDeals < ActiveRecord::Migration
  def self.up
    add_column :deals, :description, :text
  end

  def self.down
    remove_column :deals, :description
  end
end
