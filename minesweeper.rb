require "yaml"
require_relative "board"

class MinesweeperGame
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def get_input
    puts "Enter the coordinates of the tile you want to select, followed by "
    puts "'r' to reveal it or 'f' to flag/unflag it (e.g, '0,1 r')."
    puts "You can enter 'save <save_name>' to save your game to a file: "

    args = gets.chomp.split
    pos, arg = args

    pos = parse_pos(pos)

    raise "No save name given. Save aborted." if saving?(args) && arg.nil?
    raise "Invalid position: #{pos}" unless saving?(args) || valid_pos?(pos)
    raise "Invalid argument: #{arg}" unless saving?(args) || valid_arg?(arg)

    if saving?(args)
      args
    else
      [pos, arg]
    end
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

  def saving?(args)
    args[0] == "save"
  end

  def play_turn
    system("clear")
    board.render

    arg1, arg2 = get_input

    if arg1 == "save"
      save_game(arg2)
    elsif arg2 == "r"
      board[arg1].reveal
    elsif arg2 == "f"
      board[arg1].toggle_flagged
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

  def save_game(name)
    serialized_board = board.to_yaml
    File.write("#{name}.yaml", serialized_board)
  end
end

# Game start logic

def load_game(file_name)
  serialized_board = File.read(file_name)
  YAML::load(serialized_board)
end

def start_game
  flag, file_name = ARGV.slice!(0..1)
  raise "Need at least two arguments" unless flag.nil? || file_name
  raise "Too many arguments" unless ARGV.empty?

  if flag == "-l"
    board = load_game(file_name)
  elsif flag
    raise "#{flag} is not a valid argument"
  else
    board = Board.new
  end

  game = MinesweeperGame.new(board)
  game.run
end

start_game
