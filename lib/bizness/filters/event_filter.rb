module Bizness::Filters
  class EventFilter < Bizness::Filters::BaseFilter
    def call
      Hey.context(namespace: event_name) do
        Hey.publish!("executed", payload) do
          evented_call
        end
      end
    end

    private

    def evented_call
      result = filtered_operation.call
      Hey.publish!(successful? ? "succeeded" : "aborted", payload(result))
    rescue => e
      Hey.publish!("aborted", payload.merge(error: e.message, stacktrace: e.backtrace, exception: e.class.name))
      raise e
    end

    def event_name
      __original_operation__.class.name.underscore.gsub("/", Hey.configuration.delimiter)
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
