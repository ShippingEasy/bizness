module Bizness::Filters
  class ActiveRecordTransactionFilter < Bizness::Filters::BaseFilter
    def call
      ActiveRecord::Base.transaction(requires_new: true) do
        filtered_operation.call
      end
    end
  end
end
