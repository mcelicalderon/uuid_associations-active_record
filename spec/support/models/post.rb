# frozen_string_literal: true

class Post < ActiveRecord::Base
  belongs_to :user, required: false

  has_many :comments
  has_many :attachments

  accepts_nested_attributes_for :comments, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true, create_missing_uuids: true
end
