require_relative 'ship'

class Board

  attr_reader :placed_ships

  def initialize
    @placed_ships = {}
  end

  def place(ship, positions)
    placed_ships[positions] = ship
  end

  def empty?
    placed_ships.empty?
  end

  def fire(coord)
    placed_ships.include?(coord) ? hit(coord) : "Miss"
  end

  def coords_already_hit

  end

  def hit(coord)
    placed_ships[coord].lose_hp
    'Hit'
  end
end
