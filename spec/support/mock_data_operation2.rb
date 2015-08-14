class MockDataOperation2 < MockDataOperation
  def initialize(widget_id:)
    @widget = Widget.find widget_id
  end
end
