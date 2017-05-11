class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :attachment_url
      t.datetime :expires_at
      t.string :secure_id

      t.timestamps
    end
  end
end
