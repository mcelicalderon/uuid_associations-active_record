class Post < ActiveRecord::Base
  belongs_to :user, required: false

  has_many :comments

  accepts_nested_attributes_for :comments, allow_destroy: true
end
