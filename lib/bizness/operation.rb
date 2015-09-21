module Bizness::Operation
  attr_reader :error

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def filters(*filter_overrides)
      @filter_overrides = filter_overrides.flatten.compact
    end

    def filter_overrides
      @filter_overrides
    end
  end

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

  def aborted?
    !successful?
  end

  def to_h
    {}
  end

  protected

  attr_writer :error

  private

  def filter_overrides
    Array(self.class.filter_overrides).flatten.compact.empty? ? Bizness.filters : self.class.filter_overrides
  end

  def run
    Bizness.run(self, filters: filter_overrides)
  rescue => e
    self.error = e.message
  end
end
