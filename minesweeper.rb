require_relative "board"

class MinesweeperGame
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def get_input
    puts "Enter the coordinates of the tile you want to select, followed by "
    puts "'r' to reveal it or 'f' to flag/unflag it (e.g, '0,1 r') :"

    pos, arg = gets.chomp.split
    pos = parse_pos(pos)

    raise "Invalid position: #{pos}" unless valid_pos?(pos)
    raise "Invalid argument: #{arg}" unless valid_arg?(arg)

    [pos, arg]
  rescue => exception
    puts exception
    retry
  end

  def parse_pos(string)
    row, col = string.split(",").map!(&:to_i)
    [row, col]
  end

  def valid_pos?(pos)
    pos.is_a?(Array) && pos.length == 2 && pos.all? { |n| n.between?(0, 8) }
  end

  def valid_arg?(arg)
    arg == "r" || arg == "f"
  end

  def play_turn
    system("clear")
    board.render

    pos, arg = get_input
    
    case arg

    when "r"
      board.grid[pos[0]][pos[1]].reveal
    when "f"
      board.grid[pos[0]][pos[1]].toggle_flagged
    end
  end

  def run
    play_turn until board.over?
    won = board.win?

    system("clear")
    board.reveal_bombs
    board.render

    message = won ? "You win!" : "You lose!"
    puts message
  end
end

game = MinesweeperGame.new
game.run
