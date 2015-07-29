require_relative 'ship'

class Board

  attr_reader :placed_ships

  def initialize
    @placed_ships = {}
    @prev_targets = []
  end

  def place(ship, positions)
    raise "NO WAY! You're off the freaking grid!!!!" unless coord_on_board?(positions)
    placed_ships[positions] = ship
    @placed_ships
  end

  def coord_on_board?(positions)
    ((positions[0] <= 'j') && (positions[1..-1].to_i <= 10))
    # number.to_i <= 10 ? true : false
  end


  def empty?
    placed_ships.empty?
  end

  def fire(coord)
    raise "Already fired on" if coords_already_hit?(coord)
    @prev_targets<<coord
    placed_ships.include?(coord) ? hit(coord) : "Miss"
  end

  def coords_already_hit?(coord)
    @prev_targets.any? { |a| a == coord }
  end

  def hit(coord)
    placed_ships[coord].hit
    'Hit'
  end

  def all_coords(starting_point, direction)
    (horizontal_coords(starting_point.split(0), direction) + next_number(starting_point.split(-1), direction).to_s).to_sym
  end

  def horizontal_coords letter, size, direction
    return letter unless [:W, :E].include? direction
    size.times { direction == :W ?

      x = prev_char(letter)
      letter = x


      : letter.next }

    # directon == :W ? prev_char(letter) : letter.next!
  end

  def next_number number, direction
    return number unless [:N, :S].include? direction
    direction == :N ? number.to_i - 1 : number.to_i + 1
  end

  def prev_char(char)
    (char.to_s.chr.ord - 1).chr
  end

  def get_letter(coord)
    coord.slice(0)
  end

  def get_number(coord)
    coord.slice(/\d+/).to_i
  end


end
