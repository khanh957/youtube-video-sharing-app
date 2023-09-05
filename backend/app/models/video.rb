class Video < ApplicationRecord
  after_create_commit { send_notification }

  belongs_to :user

  validates :url, presence: true
  validates :video_id, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  def self.build_from_url(user, url)
    video_data = VideoDetails.get_details(url)
    new(
      url: url,
      video_id: video_data[:video_id],
      title: video_data[:title],
      description: video_data[:description],
      user: user
    )
  end

  private

  def send_notification
    data = {
      title: title,
      user: user.email
    }
    ActionCable.server.broadcast("VideosChannel", data)
  end
end
