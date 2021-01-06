require_relative "tile"

class Board
  def initialize
    @grid = new_grid
  end

  # Create a new 9x9 grid of tiles with 10 random tiles containing bombs
  def new_grid
    indices = (0...81).to_a
    bomb_positions = indices.sample(10)

    i = -1
    bomb_count = 0

    Array.new(9) do
      Array.new(9) do
        i += 1
        if bomb_count < 10 && bomb_positions.include?(i)
          bomb_count += 1
          Tile.new(self, true)
        else
          Tile.new(self, false)
        end
      end
    end
  end
end
