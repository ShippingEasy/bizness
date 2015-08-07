module Bizness::Filters
  class EventFilter < Bizness::Filters::BaseFilter
    def call
      Hey.publish!("#{event_name}:executed", context.to_h) do
        evented_call
      end
    end

    private

    def evented_call
      filtered_operation.call
      Hey.publish!("#{event_name}:#{successful? ? "succeeded" : "failed"}", context.to_h)
    rescue => e
      context.error = e.message
      Hey.publish!("#{event_name}:failed", context.to_h)
      raise e
    end

    def event_name
      __original_operation__.class.name.underscore.gsub("/", ":")
    end
  end
end
