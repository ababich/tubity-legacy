class CreateLogTables < ActiveRecord::Migration
  def self.up
    create_table :hits_logs do |t|
      t.integer :tubity_link_id

      t.string  :referer
      t.string  :remote_ip
      t.string  :remote_host

      t.binary  :compressed_request

      t.timestamps
    end
    add_index :hits_logs, :tubity_link_id

    create_table :links_logs do |t|
      t.integer :tubity_link_id

      t.binary  :compressed_data

      t.timestamps
    end
    add_index :links_logs, :tubity_link_id
  end

  def self.down
    remove_index :links_logs, :tubity_link_id
    remove_index :hits_logs, :tubity_link_id

    drop_table :links_logs
    drop_table :hits_logs
  end
end
