class Tile
  def initialize(bombed)
    @bombed = bombed
    @flagged = false
    @revealed = false
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
