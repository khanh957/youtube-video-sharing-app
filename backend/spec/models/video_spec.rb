require 'rails_helper'

RSpec.describe Video do
  let(:user) { FactoryBot.create(:user) }

  it 'is valid with valid attributes' do
    video = FactoryBot.build(:video, user: user)
    expect(video).to be_valid
  end

  it 'is not valid without a user' do
    video = FactoryBot.build(:video, user: nil)
    expect(video).not_to be_valid
    expect(video.errors[:user]).to include("must exist")
  end

  it 'is not valid without a url' do
    video = FactoryBot.build(:video, user: user, url: nil)
    expect(video).not_to be_valid
    expect(video.errors[:url]).to include("can't be blank")
  end

  it 'is not valid without a video_id' do
    video = FactoryBot.build(:video, user: user, video_id: nil)
    expect(video).not_to be_valid
    expect(video.errors[:video_id]).to include("can't be blank")
  end

  it 'is not valid without a title' do
    video = FactoryBot.build(:video, user: user, title: nil)
    expect(video).not_to be_valid
    expect(video.errors[:title]).to include("can't be blank")
  end

  it 'is not valid without a description' do
    video = FactoryBot.build(:video, user: user, description: nil)
    expect(video).not_to be_valid
    expect(video.errors[:description]).to include("can't be blank")
  end

  describe '.build_from_url' do
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

      it 'creates a video' do
        video = Video.build_from_url(user, valid_url)
        expect(video).to be_valid
      end

      it 'sets the video attributes correctly' do
        video = Video.build_from_url(user, valid_url)
        expect(video.video_id).to eq('VIDEO_ID_12')
        expect(video.title).to eq('Video Title')
        expect(video.description).to eq('Video Description')
        expect(video.url).to eq(valid_url)
        expect(video.user).to eq(user)
      end
    end

    context 'when given an invalid URL' do
      it 'raises a VideoDetails::UrlError' do
        expect { Video.build_from_url(user, invalid_url) }.to raise_error(VideoDetails::UrlError, 'Invalid link')
      end
    end

    context 'when the video is not available' do
      before do
        stub_request(:get, /www.googleapis.com\/youtube\/v3\/videos/).
          to_return(status: 200, body: { 'items' => [] }.to_json)
      end

      it 'raises a VideoDetails::UrlError' do
        expect { Video.build_from_url(user, valid_url) }.to raise_error(VideoDetails::UrlError, "Url is not valid, video is not found: #{valid_url}")
      end
    end
  end

  describe "#send_notification" do
    it "broadcasts a notification after creating a video" do
      video = FactoryBot.build(:video, user: user)

      data = {
        title: video.title,
        user: user.email
      }

      expect { video.save }.to have_broadcasted_to("VideosChannel").with(data)
    end
  end
end
