require 'open-uri'

class Video < ActiveRecord::Base
  validate :validate_has_attachment, :validate_has_expires_at
  before_save :transcode_video

  def fresh?
    !self.expires_at.nil? && self.expires_at > Time.zone.now
  end

  def validate_has_attachment
    if attachment_url.nil? || attachment_url.length < 1
      errors.add(:video, "- A video is required.")
    end
  end

  def validate_has_expires_at
    if expires_at.nil?
      errors.add(:expires, "- An expiration date is required.")
    end
  end

  def transcode_video
    if self.attachment_url.length > 0 && self.output_video_url.nil?

      attachment_url = self.attachment_url.sub(/https:/, "http:")

      attachment_file  = open(attachment_url) {|f|
        f.read
      }

      web_mp4_preset_id = '1351620000000-100070'

      pipeline_id = '1415839556295-17cp55'

      s3 = AWS::S3.new
      bucket = s3.buckets['expiringvideos']
      id = self.secure_id
      object = bucket.objects["#{id}"]
      object.write(attachment_file)

      transcoder = AWS::ElasticTranscoder::Client.new
      transcoder.create_job(
        pipeline_id: pipeline_id,
        input: {
          key: "#{id}",
          frame_rate: 'auto',
          resolution: 'auto',
          aspect_ratio: 'auto',
          interlaced: 'auto',
          container: 'auto'
        },
        output: {
          key: "#{id}.mp4",
          preset_id: web_mp4_preset_id,
          thumbnail_pattern: "",
          rotate: '0'
        }
      ) 

      video_url = "https://s3-us-west-1.amazonaws.com/expiringvideos/#{id}.mp4"

      self.output_video_url = video_url
      self.save!

    end
  end
end
