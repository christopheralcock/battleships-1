require_relative 'ship'

class Board

  attr_reader :placed_ships

  def initialize
    @placed_ships = {}
    @prev_targets = []
  end

  def place(ship, size, coords, direction)
    fail 'Coordinates already occupied' if coords_in_use?(coords)
    fail 'Off Grid' unless coord_on_board?(coords, size, direction)
    get_coords(coords, size, direction).each do |xy|
     placed_ships[xy] = ship
   end
    @placed_ships
  end

  def coords_in_use?(coords)
    placed_ships[coords] != nil
  end

  def coord_on_board?(coords, size, direction)
    coord = get_coords(coords, size, direction).last
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

  def get_coords(coord, size, direction)
   coords = [coord]
   (size - 1).times { coords << (direction == :horizontal ? next_horizontal(coords.last) : next_vertical(coords.last)) }
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
