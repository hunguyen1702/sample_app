class Micropost < ApplicationRecord
  belongs_to :user
  scope :desc_order, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost_model.max_length_content}
  validate :picture_size

  private

  def picture_size
    errors.add :picture, t("microposts.img_warn") if
      picture.size > Settings.micropost_model.img_file_size.megabytes
  end
end
