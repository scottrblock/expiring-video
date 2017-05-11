json.array!(@videos) do |video|
  json.extract! video, :id, :attachment_url, :expires_at
  json.url video_url(video, format: :json)
end
