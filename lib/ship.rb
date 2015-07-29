class Ship

  attr_reader :size
  attr_reader :hp

  def initialize(size)
    @size = size
    @hp = size
  end
end
