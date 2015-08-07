module Bizness::Subscriber
  def self.subscribe(*event_names)
    event_names.each do |event_name|
      Hey.subscribe(event_name) do |event|
        self.call!(event[:metadata])
      end
    end
  end
end
