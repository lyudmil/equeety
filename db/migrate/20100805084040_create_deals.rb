class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.string :startup_name
      t.string :website
      t.string :contact_name
      t.string :contact_email
      t.string :logo_url
      t.decimal :required_amount, :precision => 10, :scale => 2
      t.decimal :proposed_valuation, :precision => 12, :scale => 2
      t.datetime :closing_date
      t.string :round

      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
