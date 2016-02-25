module Bizness::Filters
  class EventFilter < Bizness::Filters::BaseFilter
    def call
      Hey.publish!("#{event_name}#{delimiter}executed", payload) do
        evented_call
      end
    end

    private

    def evented_call
      result = filtered_operation.call
      event_status = (respond_to?(:successful?) && !successful?) ? "failed" : "succeeded"
      Hey.publish!("#{event_name}#{delimiter}#{event_status}", payload(result))
      result
    rescue Exception => e
      Hey.publish!("#{event_name}#{delimiter}aborted", payload.merge(error: e.message, stacktrace: e.backtrace, exception: e.class.name))
      raise e
    end

    def event_name
      __original_operation__.class.name.underscore.gsub("/", delimiter)
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

    def delimiter
      Hey.configuration.delimiter
    end
  end
end
