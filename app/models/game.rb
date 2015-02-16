class Game < ActiveRecord::Base
  has_many :players
  has_many :users, through: :players

  validates_length_of :users, maximum: 2, message: "can have at most two players."

  serialize :board

  def self.waiting
    Game.where(:players_count => 1)
  end

  def self.active
    Game.where(:finished => false)
  end

  def self.contestants(id, number)
    self.update(id, :num_contestants => number)
  end

  def self.add_player2_email(id, email)
    self.update(id, :player2_email => email)
  end

  def self.add_to_turn_count(id)
    turns = (self.select('turn_count').where(:id => id).limit(1).first.turn_count) + 1
    self.update(id, :turn_count => turns)
  end

  def self.update_board(id, board)
    self.update(id, :board => board)
  end

  def can_move?(id, user_email)
    if self.turn_count.even?
      user_email == Game.select(:player2_email).where(:id => id).limit(1).first.player2_email
    else
      user_email == Game.select(:player1_email).where(:id => id).limit(1).first.player1_email
    end
  end

  def self.create_board(user_email)
    self.create(board: [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]], turn_count: 0, num_contestants: 1, player1_email: user_email, finished: false)
  end

  def self.game_state(game_id)
    self.select('id, board, turn_count').where(:id => game_id)
  end

  def self.existing_game(player_email)
    game = self.where("num_contestants = 2 AND player1_email = '#{player_email}'")
    if game.empty?
      game = self.where("num_contestants = 2 AND player2_email = '#{player_email}'")
    end
    game
  end
end
