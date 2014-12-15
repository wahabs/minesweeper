require 'byebug'

class Tile

  attr_accessor :position, :state, :board

  def initialize(position, state, board)
    @position = position
    @state = state #
    @board = board
  end

  def reveal
  end

  def neighbors
  end

  def neighbor_bomb_count
  end

  def inspect
    #{}"Position: #{position}, State: #{state}"
  end

end

class Board

  attr_accessor :grid

  # def self.new_board
  #   b = Board.new
  #   b.make_grid(9)
  #   b
  # end

  def initialize
    #@grid = Array.new(9) { Array.new(9) }
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
      row.each do |tile|
        p tile
      end
    end
  end


  def make_grid(grid_size)
    self.grid = Array.new(grid_size) { Array.new(grid_size) }
    (0...grid_size).each do |r|
      (0...grid_size).each do |c|
        self[[r, c]] = Tile.new([r, c], :none, self)
      end
    end
    seed_bombs(5)
  end

  def seed_bombs(num)
    num.times do
      self[[rand(8), rand(8)]].state = :bomb
    end
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



b = Board.new

#b[[3,4]] = Tile.new([3,4], :none, b)
b.display_board
