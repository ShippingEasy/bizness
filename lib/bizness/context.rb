require "ostruct"

class Bizness::Context < OpenStruct
  attr_accessor :error

  def successful?
    error.nil?
  end

  # If a value responds to #id, automatically set an equivalent "_id" key/value pair. For example, if an instance
  # of an ActiveRecord class Widget is set on a context object of :widget, set another attribute called :widget_id with
  # the value of the object's ID. This helps ensure the context's values can be sent as a message across application
  # boundries.
  def to_h
    super.each { |k, v| send("#{k}_id=", v.id) if v.respond_to?(:id) && send("#{k}_id").nil? }
    super
  end
end
