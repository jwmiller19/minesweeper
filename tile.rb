require_relative "board"

class Tile
  def initialize(board, bombed)
    @board = board
    @bombed = bombed
    @flagged = false
    @revealed = false
  end

  # Omit the board to avoid recursive output for inspect
  def inspect
    "#{self.class.name}:#{self.object_id} " +
    "@bombed=#{@bombed}, @flagged=#{@flagged}, @revealed=#{@revealed}"
  end

  def bombed?
    @bombed
  end

  def flagged?
    @flagged
  end

  def revealed?
    @revealed
  end

  def toggle_flagged
    flagged? ? @flagged = false : @flagged = true
  end

  # Reveal a tile and return neighbor_bomb_count. Also reveal all neighboring
  # tiles recursively unless any neighbors have bombs. Never reveal a tile if
  # it is flagged
  def reveal
    return if revealed? || flagged?
    @revealed = true
    return if bombed?

    bombs = neighbor_bomb_count

    neighbors.each(&:reveal) unless bombs > 0

    bombs
  end

  # Return an array of all tiles neighboring self (including diagonals)
  def neighbors
    neighbor_tiles = []
    grid = @board.grid

    all_tiles = grid.flatten
    self_index = all_tiles.index(self)
    self_row = self_index / grid.length
    self_col = self_index % grid.length
    self_pos = [self_row, self_col]

    grid.each_index do |row|
      grid[row].each_index do |col|
        pos = [row, col]
        neighbor_tiles << grid[row][col] if neighbor?(self_pos, pos)
      end
    end

    neighbor_tiles
  end

  # Check if other_pos is a neighboring position of self_pos
  def neighbor?(self_pos, other_pos)
    self_row, self_col = self_pos
    row, col = other_pos

    same_row = row == self_row
    same_col = col == self_col

    left_or_right = col == self_col - 1 || col == self_col + 1
    up_or_down = row == self_row - 1 || row == self_row + 1

    diagonal = left_or_right && up_or_down

    if (same_row && left_or_right) || (same_col && up_or_down) || diagonal
      true
    else
      false
    end
  end

  def neighbor_bomb_count
    neighbors.count(&:bombed?)
  end

end
