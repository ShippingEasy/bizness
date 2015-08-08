require "spec_helper"

describe Bizness::Subscriber do
  let(:event_name) { "cancel_account:succeeded" }

  before do
    MockOperation.extend(Bizness::Subscriber)
    MockOperation.subscribe event_name
  end

  describe ".subscribe" do
    it "executes the operation if the subscribed event is broadcasted" do
      expect(MockOperation).to receive(:call!).with({ foo: "bar"})

      Hey.subscribe!(event_name) do
        Thread.current[:ugh] = true
      end

      Hey.publish!(event_name, { foo: "bar"} )
    end
  end
end
