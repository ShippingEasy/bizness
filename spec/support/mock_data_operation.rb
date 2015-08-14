class MockDataOperation < Bizness::Operation

  attr_reader :widget

  def initialize(widget:)
    @widget = widget
  end

  def call
    widget.update_column :name, "Boo"
  end

  def to_h
    { widget_id: widget.id, name: widget.name }
  end
end
