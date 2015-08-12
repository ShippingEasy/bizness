module Bizness::Filters
  class EventFilter < Bizness::Filters::BaseFilter
    def call
      Hey.publish!("#{event_name}:executed", payload) do
        evented_call
      end
    end

    private

    def evented_call
      result = filtered_operation.call
      Hey.publish!("#{event_name}:#{successful? ? "succeeded" : "failed"}", payload(result))
    rescue => e
      Hey.publish!("#{event_name}:failed", payload.merge(error: e.message))
      raise e
    end

    def event_name
      __original_operation__.class.name.underscore.gsub("/", ":")
    end

    def payload(result = nil)
      if self.respond_to?(:to_h)
        to_h
      elsif result.is_a?(Hash)
        result
      else
        Hash.new
      end
    end
  end
end
