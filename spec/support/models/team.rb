# frozen_string_literal: true

class Team < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :name, presence: true
end
