# frozen_string_literal: true

class User < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :pets

  has_many :posts

  validates :name, presence: true
end
