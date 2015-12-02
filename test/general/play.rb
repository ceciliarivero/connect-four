require "cuba/test"
require_relative "../../app"

prepare do
  # Create Board
  board = Board.create({
    rows: 6,
    cols: 7,
    last_move: nil
  })

  # Create Game
  game = Game.create({
    board: board
  })

  # Create Player 1
  Player.create({
    name: "X",
    game: game
  })

  # Create Player 2
  Player.create({
    name: "O",
    game: game
  })
end

scope do
  test "play" do
    assert_equal [true, :ok], Player[2].move(5)
    assert_equal [false, :wrong_turn], Player[2].move(5)
    assert_equal '[5,0,"O"]', Board[1].last_move

    assert_equal [true, :ok], Player[1].move(0)
    assert_equal [true, :ok], Player[2].move(1)

    assert_equal [true, :ok], Player[1].move(1)
    assert_equal [true, :ok], Player[2].move(2)

    assert_equal [true, :ok], Player[1].move(2)
    assert_equal [true, :ok], Player[2].move(3)

    assert_equal [true, :ok], Player[1].move(2)
    assert_equal [true, :ok], Player[2].move(3)

    assert_equal [true, :ok], Player[1].move(3)
    assert_equal [true, :ok], Player[2].move(6)

    assert_equal [true, :game_over], Player[1].move(3)

    p Board[1].grid
  end
end
