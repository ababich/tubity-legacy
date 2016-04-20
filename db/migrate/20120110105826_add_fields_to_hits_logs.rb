class AddFieldsToHitsLogs < ActiveRecord::Migration
  def self.up
    remove_column :hits_logs, :compressed_request

    add_column :hits_logs, :user_agent, :string
    add_column :hits_logs, :http_cookie, :string
  end

  def self.down
    add_column :hits_logs, :compressed_request, :binary

    remove_column :hits_logs, :user_agent
    remove_column :hits_logs, :http_cookie
  end
end
