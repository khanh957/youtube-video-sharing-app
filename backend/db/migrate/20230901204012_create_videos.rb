class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :url,         null: false
      t.string :video_id,    null: false
      t.string :title,       null: false
      t.string :description, null: false
      t.references :user,    null: false, foreign_key: true

      t.timestamps
    end
  end
end
