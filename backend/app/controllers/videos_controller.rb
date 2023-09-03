class VideosController < ApplicationController
  before_action :authenticate_user, only: [:create]

  def index
    videos = Video.limit(params[:limit]).offset(params[:offset]).order(created_at: :desc).includes(:user)
    render json: { data: videos.map { |i| video_serializer(i) } }
  end

  def create
    video = Video.build_from_url(@current_user, params[:video_url])

    if video.save
      render json: { data: video_serializer(video) }, status: :created
    else
      render json: { errors: video.errors.full_messages }, status: :unprocessable_entity
    end
  rescue VideoDetails::UrlError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def authenticate_user
    token = request.headers['HTTP_AUTHORIZATION']&.split(' ')&.last
    if token
      begin
        decoded_token = Auth.decode(token)
        user_id = decoded_token['user_id']
        user = User.find(user_id)
        @current_user = user
      rescue JWT::DecodeError
        return [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']]
      rescue ActiveRecord::RecordNotFound
        return [404, { 'Content-Type' => 'application/json' }, [{ error: 'User not found' }.to_json]]
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def video_serializer(video)
    {
      id: video.id,
      url: video.url,
      video_id: video.video_id,
      title: video.title,
      description: video.description,
      user: {
        email: video.user.email,
      }
    }
  end
end
