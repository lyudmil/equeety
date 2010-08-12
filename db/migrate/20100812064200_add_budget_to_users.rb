class AddBudgetToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :budget, :decimal, :precision => 12, :scale => 2
  end

  def self.down
    remove_column :users, :budget
  end
end
