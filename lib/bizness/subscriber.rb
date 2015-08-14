module Bizness::Subscriber
  def subscribe(*event_names, &block)
    event_names.each do |event_name|
      Hey.subscribe!(event_name) do |event|
        instance = block_given? ? block.call(event[:metadata]) : new(event[:metadata])
        instance.call!
      end
    end
  end
end
