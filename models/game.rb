class Game < Ohm::Model
  reference :winner, :Player
  reference :board, :Board

  def move(col, player)
    begin
      return [false, :game_over]  unless winner.nil?
      return [false, :wrong_turn] unless turn(player)
      return [false, :illegal]    unless board.move(col, player)
    rescue Board::Finished
      update(winner: player)
      return [true, :game_over]
    end

    [true, :ok]
  end

  def turn(player)
    return true unless board.last_move

    last_move = JSON.parse(board.last_move)

    last = last_move.last

    last != player.name
  end
end
