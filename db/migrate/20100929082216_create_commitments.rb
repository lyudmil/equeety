class CreateCommitments < ActiveRecord::Migration
  def self.up
    create_table :commitments do |t|
      t.decimal :amount, :precision => 12, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :commitments
  end
end
