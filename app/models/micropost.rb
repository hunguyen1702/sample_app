class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost_model.max_length_content}
  validate :picture_size

  scope :desc_order, ->{order created_at: :desc}
  scope :new_feed, ->(id, following_ids) do
    where "user_id IN (?) OR user_id = ?", following_ids, id
  end

  private

  def picture_size
    errors.add :picture, t("microposts.img_warn") if
      picture.size > Settings.micropost_model.img_file_size.megabytes
  end
end
