require_relative "board"

class Tile
  def initialize(board, bombed)
    @board = board
    @bombed = bombed
    @flagged = false
    @revealed = false
  end

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

  def switch_flagged
    flagged? ? @flagged = false : @flagged = true
  end

  def reveal
    @revealed = true unless revealed?
  end
end
