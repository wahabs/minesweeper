require 'byebug'

class Tile

  attr_accessor :position, :board, :bombed, :flagged, :revealed

  def initialize(position, board, bombed = false, flag = "*", revealed = false)
    @position = position
    @bombed = bombed
    @flag = flag
    @revealed = revealed
    @board = board
  end

  def reveal
    revealed = true
    if bombed
      flag = "B"
      return true
    end
    flag = neighbor_bomb_count
    if neighbor_bomb_count == 0
      neighbors.each { |neighbor| neighbor.reveal }
    end
    return false

  end

  def neighbors
    x = position[0]
    y = position[1]
    ret = []
    (-1..1).each do |delx|
      (-1..1).each do |dely|
        if (0..8).cover?(x+delx) && (0..8).cover?(y+dely)
        ret << board[[x+delx, y+dely]] unless delx == 0 && dely == 0
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

  def inspect
    flag
    #{}"#{position}#{flag}"
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
    grid.each do |row|
      p row
    end
  end


  def make_grid(grid_size)
    self.grid = Array.new(grid_size) { Array.new(grid_size) }
    (0...grid_size).each do |r|
      (0...grid_size).each do |c|
        self[[r, c]] = Tile.new([r, c], self)
      end
    end
    seed_bombs(10)
  end

  def seed_bombs(num)
    num.times { self[[rand(8), rand(8)]].bombed = true }
  end


  def play

    puts "Enter coordinates (add -f to flag)"
    action = gets.chomp.split(" ")
      if action.include?("f")
        #flag
      else
        #reveal
      end

  end
end



# b = Board.new
# b.display_board
#b[[3,4]] = Tile.new([3,4], :none, b)
#b.display_board
