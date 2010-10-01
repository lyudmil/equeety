class AddUserToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :user_id, :integer
  end

  def self.down
    remove_column :invitations, :user_id
  end
end
