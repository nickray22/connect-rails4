class GamesController < ApplicationController

 def show

 end

  def join
    @user = current_user
    if @user.nil?
      flash[:alert] = 'You must be logged in to join a game.'
    else
      game = Game.waiting.all
      if game.empty?
        exist = Game.existing_game(@user.email).all
        if exist.empty?
          c4board = Game.create_board(@user.email)
          @board = c4board.board
          @welcome = "#{@user.email} is waiting for an opponent to join."
          @your_turn = true
          render :show
        else
          game = exist.first
          @welcome = "#{game.player1_email} VS. #{game.player2_email}"
          @board = Game.game_state(game.id)
          if (@board.first.turn_count.even?) && (@user.email == game.player2_email)
            @your_turn = true
          elsif (@board.first.turn_count.odd?) && (@user.email == game.player1_email)
            @your_turn = true
          end
          render :show
        end
      elsif (game.first.player1_email == @user.email) || (game.first.player2_email == @user.email)
        if game.first.player2_email.nil?
          @welcome = "#{@user.email} is waiting for an opponent to join."
        else
          @welcome = "#{game.first.player1_email} VS. #{game.first.player2_email}"
        end
        @board = Game.game_state(game.first.id)
        @your_turn = true if @board.first.turn_count == 0
        render :show
      elsif game.first.player2_email == @user.email
        @welcome = "#{game.first.player1_email} VS. #{game.first.player2_email}"
        @board = Game.game_state(game.first.id)
        @your_turn = true if @board.first.turn_count == 0
      else
        Game.add_player2_email(game.first.id, @user.email)
        Game.contestants(game.first.id, 2)
        game = Game.existing_game(@user.email).first
        @welcome = "#{game.player1_email} VS. #{@user.email}"
        @board = Game.game_state(game.id)
        @your_turn = true
        render :show
      end
    end
  end

  def move
    @user = current_user
    @game = Game.existing_game(@user.email).all.first
    @welcome = "#{@game.player1_email} VS. #{@game.player2_email}"
    @board = Game.game_state(@game.id)
    @your_turn = @game.can_move?(@game.id, @user.email)
    if @your_turn
      array = []
      [*0..5].each do |n|
        array << @board.first.board[n][params[:column].to_i]
      end
      position = nil
      [6, 5, 4, 3, 2, 1, 0].each do |n|
        if array[n] == 0
          position = n
          break
        end
      end
      if position.nil?
        render :show
      else
        new_board = @board.first.board
        if @game.player1_email == @user.email
          new_board[position][params[:column].to_i] = 1
        else
          new_board[position][params[:column].to_i] = 2
        end
        Game.update_board(@game.id, new_board)

        # Check for winning conditions here - add additional logic in board partial to handle a win

        Game.add_to_turn_count(@game.id)
        @your_turn = false
        render :show
      end
    else
      # Never reach here - page doesn't give player option to move if it isn't his or her turn
    end
  end

end
