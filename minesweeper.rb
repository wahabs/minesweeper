require 'byebug'

class Tile

  attr_accessor :position, :board, :bombed, :flag, :revealed

  def initialize(position, board, bombed = false, flag = "-", revealed = false)
    @position = position
    @bombed = bombed
    @flag = flag
    @revealed = revealed
    @board = board
  end

  def player_flag
    self.flag = "F"
  end

  def found_bomb?
    self.revealed = true
    if bombed
      board.reveal_bombs
      #self.flag = "B"
      return true
    end
    self.flag = neighbor_bomb_count
    if self.flag == 0
      self.flag = "."
      neighbors.each do |neighbor|
        unless neighbor.flag == "F" || neighbor.revealed
          neighbor.found_bomb?
        end
      end
    end

    false
  end

  def neighbors
    x = position[0]
    y = position[1]
    ret = []
    (-1..1).each do |delx|
      (-1..1).each do |dely|
        if (0..8).cover?(x + delx) && (0..8).cover?(y + dely)
          ret << board[[x + delx, y + dely]] unless delx == 0 && dely == 0
        end
      end
    end
    ret
  end

  def neighbor_bomb_count
    count = 0
    neighbors.each do |neighbor|
      count += 1 if neighbor.bombed
    end
    count
  end

  def to_s
    " #{flag}"
  end

end

class Board

  attr_accessor :grid

  def initialize
    make_grid(9)
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos, mark)
    self.grid[pos[0]][pos[1]] = mark
  end

  def display_board
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, r|
      print r
      row.each_with_index do |col, c|
        print self[[r, c]]
      end
      puts ""
    end
  end


  def make_grid(grid_size)
    self.grid = Array.new(grid_size) { Array.new(grid_size) }
    (0...grid_size).each do |r|
      (0...grid_size).each do |c|
        self[[r, c]] = Tile.new([r, c], self)
      end
    end
    seed_bombs(5)
  end

  def seed_bombs(num)
    num.times { self[[rand(8), rand(8)]].bombed = true }
  end


  def play

    until won?

      display_board
      action = get_input
      coordinates = [action[0].to_i, action[1].to_i]

      if action.include?("-f")
        self[coordinates].player_flag
      elsif self[coordinates].found_bomb?
          display_board
          puts "You lose."
          break
      end

    end

    puts "You win!" if won?

  end

  def get_input
    print "Enter coordinates (add -f to flag): " #"1 2 -f"
    gets.chomp.split(" ")
  end

  def reveal_bombs
    grid.each_with_index do |row, r|
      row.each_with_index do |col, c|
        self[[r, c]].flag = "B" if self[[r, c]].bombed
      end
    end
  end


  def won?
    grid.each_with_index do |row, r|
      row.each_with_index do |col, c|
        return false unless self[[r, c]].revealed || self[[r, c]].bombed
      end
    end
    true
  end

end



b = Board.new
b.play
#b.display_board
#b[[3,4]] = Tile.new([3,4], :none, b)
#b.display_board
