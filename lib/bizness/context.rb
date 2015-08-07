require "ostruct"

class Bizness::Context < OpenStruct
  attr_accessor :error

  def successful?
    error.nil?
  end
end
