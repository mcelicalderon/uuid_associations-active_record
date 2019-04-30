class Attachment < ActiveRecord::Base
  belongs_to :post, required: false
end
