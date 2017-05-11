class ChangeTimeFormatInVideos < ActiveRecord::Migration
  def change
    change_column :videos, :expires_at, :time
  end
end
