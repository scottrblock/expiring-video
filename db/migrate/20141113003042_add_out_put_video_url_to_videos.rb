class AddOutPutVideoUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :output_video_url, :string
  end
end
