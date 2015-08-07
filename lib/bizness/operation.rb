class Bizness::Operation
  extend Forwardable

  def_delegators :context, :successful?

  attr_reader :context

  def initialize(context = {})
    @context = Bizness::Context.new(context)
  end

  def self.filters
    Bizness.filters
  end

  def call!
    execute_filtered_operation!
    context
  end

  def call
    raise NotImplementedError
  end

  def fail!(error:)
    context.error = error
  end

  private

  def execute_filtered_operation!
    filtered_operation.call
    raise Failure, context unless successful?
  rescue => e
    context.error = e.message
  end

  def filtered_operation
    return self if self.class.filters.empty?
    self.class.filters.reduce(self) { |filtered_op, filter| filter.new(filtered_op) }
  end
end
