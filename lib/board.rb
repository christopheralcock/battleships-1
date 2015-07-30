require_relative 'ship'

class Board

  attr_reader :placed_ships

  def initialize
    @placed_ships = {}
    @prev_targets = []
    # @coords_not_available = []
  end

  def place(ship, coords, direction)
    fail 'Off Grid' unless coord_on_board?(ship, coords, direction)
    get_coords(ship, coords, direction).each do |xy|
      if coords_in_use?(coords)
        placed_ships = placed_ships.invert.delete(ship)
        fail 'Coordinates already occupied'
      else
        placed_ships[xy] = ship
      end
      # @coords_not_available << xy
    end
    @placed_ships
  end

  def coords_in_use?(coords)
    placed_ships[coords] != nil
  end

  def coord_on_board?(ship, coords, direction)
    coord = get_coords(ship.size, coords, direction).last
    ((coord[0] <= 'j') && (coord[1..-1].to_i <= 10))

  end

  def fire(coord)
    fail 'Already fired on' if coords_already_hit?(coord)
    @prev_targets << coord
    placed_ships.include?(coord) ? hit(coord) : 'Miss'
  end

  def coords_already_hit?(coord)
    @prev_targets.any? { |a| a == coord }
  end

  def hit(coord)
    placed_ships[coord].hit
    'Hit'
  end

  def get_coords(ship, coord, direction)
   coords = [coord]
   (ship.size - 1).times { coords << (direction == :horizontal ? next_horizontal(coords.last) : next_vertical(coords.last)) }
   coords
  end

  def next_horizontal(coords)
    coords.to_s.reverse.next.reverse.to_sym
  end

  def next_vertical(coords)
    x, y = coords.to_s.split('', 2)
    (x + y.next).to_sym
  end

  private

  def empty?
    placed_ships.empty?
  end
end
