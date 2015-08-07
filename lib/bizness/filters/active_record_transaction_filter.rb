module Bizness::Filters
  class ActiveRecordTransactionFilter < Bizness::Filters::BaseFilter
    def call
      ActiveRecord::Base.transaction(requires_new: true) do
        filtered_operation.call
        raise ActiveRecord::Rollback unless successful?
      end
    end
  end
end
