class Tile

  attr_accessor :position, :state, :board

  def initialize(position, state, board = Board.new)
    @position = position
    @state = state # bombed, flagged, revealed
    @board = board
  end

  def reveal
  end

  def neighbors
  end

  def neighbor_bomb_count
  end

  def inspect
    "Position: #{position}, State: #{state}"
  end

end

class Board

  attr_accessor :grid

  def initialize(grid_size = 9)
    @grid = make_grid(grid_size)
  end

  def [](pos)
    grid[pos[0], pos[1]]
  end

  def []=(pos, mark)
    self.grid[pos[0], pos[1]] = mark
  end

  def print_board
    grid.each do |row|
      row.each do |tile|
        p tile
      end
    end
  end


  private

    def make_grid(grid_size)
      self.grid = Array.new(grid_size) { Array.new(grid_size) }
      (0..grid_size).each do |r|
        (0..grid_size).each do |c|
          self[[r, c]] = Tile.new([r, c], nil, self)
        end
      end
      self.grid
    end


end
