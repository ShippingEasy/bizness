module Bizness::Subscriber
  def subscribe(*event_names)
    event_names.each do |event_name|
      Hey.subscribe!(event_name) do |event|
        call!(event[:metadata])
      end
    end
  end
end
