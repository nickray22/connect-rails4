class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players

  validates_length_of :users, maximum: 2, message: "can have at most two players."

  scope :waiting, -> { where(:players_count => 1) }
  scope :active, -> { where(:finished => false) }
end
