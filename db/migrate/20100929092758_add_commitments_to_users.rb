class AddCommitmentsToUsers < ActiveRecord::Migration
  def self.up
    add_column :commitments, :user_id, :integer
  end

  def self.down
    remove_column :commitments, :user_id
  end
end
