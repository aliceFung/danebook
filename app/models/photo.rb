class Photo < ActiveRecord::Base

  belongs_to :user

  has_attached_file :picture, :styles => {:thumb => "100x100"}

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  has_many :likes, as: :likings, class_name: "Like",
            dependent: :destroy

  has_many :comments, as: :commentable, class_name: "Comment",
            dependent: :destroy

end
