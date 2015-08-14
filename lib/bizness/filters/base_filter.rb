module Bizness::Filters
  class BaseFilter < SimpleDelegator
    def initialize(operation)
      @__original_operation__ = operation if __original_operation__.nil?
      super(operation)
    end

    private

    attr_reader :__original_operation__

    def filtered_operation
      __getobj__
    end
  end
end
