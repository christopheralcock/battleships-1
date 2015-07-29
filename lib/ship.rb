class Ship

  attr_reader :size
  # attr_accessor :hp

  def initialize(size)
    @size, @hits = size, 0
  end

  def hit
    @hits += 1
  end

  def alive?
    @hits < size
  end

end
