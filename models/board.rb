require "json"

class Board < Ohm::Model
  Finished = Class.new(RuntimeError)

  include Ohm::DataTypes
  include Ohm::Callbacks

  attribute :rows, Type::Integer
  attribute :cols, Type::Integer
  attribute :serialized_grid, Type::Array
  attribute :last_move

  def before_save
    self.serialized_grid = grid
  end

  def grid
    @grid ||= serialized_grid || []

    if @grid.empty?
      cols.times { |i| @grid[i] = [] }
    end

    @grid
  end

  def valid?(col)
    col < cols and grid[col].size < rows
  end

  def move(col, player)
    valid?(col) and push(col, player)
    true
  end

  def push(col, player)
    row = grid[col].size

    self.last_move = JSON.dump([col, row, player.name])
    grid[col].push(player.name)
    save

    check(col, row, player.name)
  end

  def check(col, row, player, acc = -1, x: nil, y: nil)
    if acc == 4
      raise Finished
    end

    if col < 0 || row < 0
      return false
    end

    if col >= cols || row >= rows
      return false
    end

    if player != grid[col][row]
      return false
    end

    printf("col: %d, row: %d, player: %p, acc: %d\n",
      col, row, player, acc)

    if acc == -1
      check(col, row, player, 0, x: -1, y: -1) or
      check(col, row, player, 0, x: -1, y:  0) or
      check(col, row, player, 0, x: -1, y: +1) or

      check(col, row, player, 0, x:  0, y: -1) or
      check(col, row, player, 0, x:  0, y: +1) or

      check(col, row, player, 0, x: +1, y: -1) or
      check(col, row, player, 0, x: +1, y:  0) or
      check(col, row, player, 0, x: +1, y: +1)
    else
      check(col + x, row + y, player, acc + 1, x: x, y: y)
    end
  end
end
