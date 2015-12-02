class Player < Ohm::Model
  attribute :name

  reference :game, :Game

  def move(col)
    game.move(col, self)
  end

  def inspect
    name
  end
end
