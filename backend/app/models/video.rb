class Video < ApplicationRecord
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
end
