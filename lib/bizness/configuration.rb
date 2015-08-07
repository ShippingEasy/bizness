class Bizness::Configuration
  attr_writer :filters

  def initialize
    @filters = []
  end

  def filters
    Array(@filters).flatten.compact
  end
end
