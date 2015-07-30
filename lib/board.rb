require_relative 'ship'

class Board

  attr_reader :placed_ships
  attr_reader :coords_not_available

  def initialize
    @placed_ships = {}
    @prev_targets = []
    @coords_not_available = []
  end

  def place(ship, coords, direction)
    coords = coords.downcase
    off_grid(ship, coords, direction)
    coords_in_use(ship, coords, direction)
    get_coords(ship, coords, direction).each do |coord|
      placed_ships[coord] = ship
    end
  end

  def get_coords(ship, coord, direction)
   coords = [coord]
   (ship.size - 1).times { coords << (direction == :horizontal ? next_horizontal(coords.last) : next_vertical(coords.last)) }
   coords
  end

  def off_grid(ship, coords, direction)
    fail 'Off Grid' unless coord_on_board?(ship, coords, direction)
  end

  def coords_in_use(ship, coords, direction)
    coords = get_coords(ship, coords, direction)
    fail 'Coordinates already occupied' if coords.any? &has_ships
  end

  def has_ships
    proc do |coord|
      has_ship?(coord)
    end
  end

  def has_ship?(coord)
    placed_ships.keys.include?(coord)
  end

  def coord_on_board?(ship, coords, direction)
    coord = get_coords(ship, coords, direction).last
    ((coord[0].downcase <= 'j') && (coord[1..-1].to_i <= 10))
  end

  def fire(coord)
    fail 'Already fired on' if coords_already_hit?(coord)
    @prev_targets << coord
    placed_ships.include?(coord) ? hit(coord) : 'Miss'
  end

  def hit(coord)
    placed_ships[coord].hit
    placed_ships[coord].sunk? ? 'Ship sunk' : 'Hit'
  end

  def coords_already_hit?(coord)
    @prev_targets.any? { |a| a == coord }
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
