class VideosChannel < ApplicationCable::Channel
  def subscribed
    stream_from "VideosChannel"
  end
end
