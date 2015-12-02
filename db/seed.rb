require "ohm"
require "ohm/contrib"

Dir["./models/**/*.rb"].each  { |rb| require rb }

Ohm.redis = Redic.new(ENV.fetch("OPENREDIS_URL"))

Ohm.flush

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
