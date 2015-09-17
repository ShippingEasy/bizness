module Bizness::Filters
  class BaseFilter < SimpleDelegator
    attr_reader :__original_operation__

    def initialize(operation)
      @__original_operation__ = if operation.respond_to?(:__original_operation__)
                                  operation.__original_operation__
                                else
                                  operation
                                end
      super(operation)
    end

    private

    def filtered_operation
      __getobj__
    end
  end
end
