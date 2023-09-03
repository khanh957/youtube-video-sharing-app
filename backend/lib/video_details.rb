require 'httparty'

class VideoDetails
  GOOGLE_YOUTUBE_API_KEY = ENV['GOOGLE_YOUTUBE_API_KEY']

  class UrlError < StandardError; end

  def self.get_details(url)
    video_id = extract_video_id(url)
    raise UrlError.new("Invalid link") if video_id.blank?

    # get video details from youtube
    response = HTTParty.get("https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&part=snippet&key=#{GOOGLE_YOUTUBE_API_KEY}")
    response_body = JSON.parse(response.body)
    raise UrlError.new("Url is not valid, video is not found: #{url}") if response_body['items'].blank?

    video_data = response_body['items'].first
    {
      video_id: video_data['id'],
      title: video_data.dig('snippet', 'title'),
      description: video_data.dig('snippet', 'description')
    }
  end

  private

  def self.extract_video_id(url)
    youtube_regex = %r{(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=|youtu\.be\/)|youtu\.be\/)([^"&?\/ ]{11})}
    
    match = url.match(youtube_regex)
  
    match[1] if match
  end
end
