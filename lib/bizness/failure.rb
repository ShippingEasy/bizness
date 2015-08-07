class Bizness::Failure < StandardError
  def initialize(context = nil)
    @context = context
    super
  end
end
