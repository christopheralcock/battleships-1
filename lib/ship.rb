class Ship

  attr_reader :size
  attr_reader :hp

  def initialize(size)
    @size = size
    @hp = size
  end

  def lose_hp
    @hp -= 1
  end
end
