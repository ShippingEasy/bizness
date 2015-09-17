class Bizness::Configuration
  attr_writer :filters

  def initialize
    @filters = [Bizness::Filters::ActiveRecordTransactionFilter, Bizness::Filters::EventFilter]
  end

  def filters
    Array(@filters).flatten.compact
  end
end
