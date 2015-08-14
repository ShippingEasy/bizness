class MockOperation
  include Bizness::Operation

  attr_reader :foo
  attr_accessor :custom_message

  def initialize(foo:)
    @foo = foo
  end

  def call
    self.custom_message = "Operation completed"
  end

  def to_h
    hash = { foo: foo }
    hash[:custom_message] = custom_message unless custom_message.nil?
    hash
  end
end
