require 'rails_helper'

RSpec.describe VideosController do
  describe 'GET #index' do
    before do
      WebMock.allow_net_connect!
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:video, 5, user: user)
    end

    it 'returns a list of videos' do
      get :index

      expect(response).to have_http_status(:ok)

      response_body = JSON.parse(response.body)
      expect(response_body['data'].count).to eq(5)
    end
  end

  describe 'POST #create' do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_video_url) { 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' }

    before do
      WebMock.allow_net_connect!
      allow(controller).to receive(:authenticate_user).and_return(true)
      controller.instance_variable_set(:@current_user, user)
    end

    context 'when valid video URL is provided' do
      it 'creates a new video' do
        post :create, params: { video_url: valid_video_url }

        expect(response).to have_http_status(:created)

        new_video = Video.last
        expect(new_video.user).to eq(user)
        expect(new_video.video_id).not_to be_nil
        expect(new_video.title).not_to be_nil
        expect(new_video.description).not_to be_nil
      end
    end

    context 'when invalid video URL is provided' do
      let(:invalid_url) { 'invalid_url' }

      it 'returns a bad request status' do
        post :create, params: { video_url: invalid_url }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({"error" => "Invalid link"})
      end
    end

    context 'when YouTube video is not available' do
      let(:invalid_url) { 'https://www.youtube.com/watch?v=12345678900' }

      it 'returns a bad request status' do
        post :create, params: { video_url: invalid_url }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({"error" => "Url is not valid, video is not found: #{invalid_url}"})
      end
    end

    context 'when video creation fails' do
      it 'returns an unprocessable entity status' do
        allow_any_instance_of(Video).to receive(:save).and_return(false)

        post :create, params: { video_url: valid_video_url }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
