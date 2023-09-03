require 'rails_helper'

RSpec.describe VideoDetails do
  describe '.get_details' do
    let(:valid_url) { 'https://www.youtube.com/watch?v=VIDEO_ID_12' }
    let(:invalid_url) { 'https://example.com' }
    let(:response) do
      {
        'items' => [
          {
            'id' => 'VIDEO_ID_12',
            'snippet' => {
              'title' => 'Video Title',
              'description' => 'Video Description'
            }
          }
        ]
      }.to_json
    end

    context 'when given a valid YouTube URL' do
      before do
        stub_request(:get, /www.googleapis.com\/youtube\/v3\/videos/).
          to_return(status: 200, body: response)
      end

      it 'returns video details' do
        video_data = VideoDetails.get_details(valid_url)

        expect(video_data).to eq(
          video_id: 'VIDEO_ID_12',
          title: 'Video Title',
          description: 'Video Description'
        )
      end
    end

    context 'when given an invalid URL' do
      it 'raises an error' do
        expect { VideoDetails.get_details(invalid_url) }.
          to raise_error(VideoDetails::UrlError, 'Invalid link')
      end
    end

    context 'when the video is not available' do
      before do
        stub_request(:get, /www.googleapis.com\/youtube\/v3\/videos/).
          to_return(status: 200, body: { 'items' => [] }.to_json)
      end

      it 'raises an error' do
        expect { VideoDetails.get_details(valid_url) }.
          to raise_error(VideoDetails::UrlError, "Url is not valid, video is not found: #{valid_url}")
      end
    end
  end

  describe '.extract_video_id' do
    it 'extracts video ID from a valid URL' do
      url = 'https://www.youtube.com/watch?v=VIDEO_ID_12'
      video_id = VideoDetails.extract_video_id(url)
      expect(video_id).to eq('VIDEO_ID_12')
    end

    it 'returns nil for an invalid URL' do
      url = 'invalid_url'
      video_id = VideoDetails.extract_video_id(url)
      expect(video_id).to be_nil
    end
  end
end
