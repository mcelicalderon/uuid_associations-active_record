# frozen_string_literal: true

class Toy < ActiveRecord::Base
  belongs_to :pet

  validates :name, presence: true
end
