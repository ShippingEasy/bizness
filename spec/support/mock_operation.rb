class MockOperation < Bizness::Operation
  def call
    context.custom_message = "Operation completed"
  end
end
