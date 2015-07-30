require_relative 'ship'

class Board

  attr_reader :placed_ships
  attr_reader :coords_not_available
  attr_reader :ships_on_board
  attr_reader :number_of_hits
  attr_reader :number_of_misses

  def initialize
    @placed_ships = {}
    @prev_targets = []
    @coords_not_available = []
    @ships_on_board = []
    @number_of_hits = []
    @number_of_misses = []
  end

  def place(ship, coords, direction)
    coords = coords.downcase
    off_grid(ship, coords, direction)
    coords_in_use(ship, coords, direction)
    placing_ships(ship, coords, direction)
    @ships_on_board << ship
  end

  def placing_ships(ship, coords, direction)
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
    fail 'Coordinates already occupied' if coords.any?(&ships?)
  end

  def ships?
    proc do |coord|
      ship?(coord)
    end
  end

  def ship?(coord)
    placed_ships.keys.include?(coord)
  end

  def coord_on_board?(ship, coords, direction)
    coord = get_coords(ship, coords, direction).last
    ((coord[0].downcase <= 'j') && (coord[1..-1].to_i <= 10))
  end

  def fire(coords)
    fail 'Already fired on' if coords_already_hit?(coords)
    @prev_targets << coords
    placed_ships.include?(coords) ? hit(coords) : miss(coords)
  end

  def miss(coords)
    @number_of_misses << coords
    'Miss'
  end

  def hit(coords)
    @number_of_hits << coords
    placed_ships[coords].hit
    placed_ships[coords].sunk? ? sunk_ship(placed_ships[coords]) : 'Hit'
  end

  def sunk_ship(ship)
    @ships_on_board.delete(ship)
    'Ship sunk'
  end

  def victory?
    @number_of_hits.count > 0 && @ships_on_board.empty?
  end

  def coords_already_hit?(coords)
    @prev_targets.any? { |coord| coord == coords }
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
