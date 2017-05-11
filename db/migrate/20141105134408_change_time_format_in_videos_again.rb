class ChangeTimeFormatInVideosAgain < ActiveRecord::Migration
  def change
    change_column :videos, :expires_at, :datetime
  end
end
