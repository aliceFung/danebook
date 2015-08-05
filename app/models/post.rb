class Post < ActiveRecord::Base

  belongs_to :user
  has_many :likes, as: :likings, class_name: "Like", dependent: :destroy
  has_many :comments, as: :commentable, class_name: "Comment"

  validates :body, :presence => :true

  def you_liked?

  end

end
