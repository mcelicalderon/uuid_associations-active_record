class Pet < ActiveRecord::Base
  has_and_belongs_to_many :users

  has_many :toys

  validates :name, presence: true

  accepts_nested_attributes_for :toys, allow_destroy: true
end
