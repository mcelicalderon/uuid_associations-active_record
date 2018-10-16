class Post < ActiveRecord::Base
  belongs_to :user, required: false

  has_many :comments
end
