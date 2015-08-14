module Bizness::Operation
  attr_reader :error

  def call!
    run
    successful?
  end

  def call
    raise NotImplementedError
  end

  def successful?
    error.nil?
  end

  def to_h
    {}
  end

  protected

  attr_writer :error

  private

  def run
    Bizness.run(self)
  rescue => e
    self.error = e.message
  end
end
