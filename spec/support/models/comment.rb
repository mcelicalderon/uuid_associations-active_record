class Comment < ActiveRecord::Base
  belongs_to :post, required: false
end
