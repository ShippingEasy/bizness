require "spec_helper"

describe Bizness::Subscriber do
  let(:event_name) { "cancel_account:succeeded" }
  let!(:widget) { Widget.create(name: "Foo") }

  describe ".subscribe" do
    context "when configured with a block" do
      before do
        MockDataOperation.extend(Bizness::Subscriber)
        MockDataOperation.subscribe(event_name) do |event_data|
          found_widget = Widget.find(event_data[:widget_id])
          MockDataOperation.new(widget: found_widget)
        end
      end

      it "executes the operation if the subscribed event is broadcasted" do
        expect_any_instance_of(MockDataOperation).to receive(:call!)
        Hey.publish!(event_name, { widget_id: widget.id } )
      end
    end

    context "when not configured with a block" do
      before do
        MockOperation.extend(Bizness::Subscriber)
        MockOperation.subscribe(event_name)
      end

      it "executes the operation if the subscribed event is broadcasted" do
        expect(MockOperation).to receive(:new).with(foo: "baz").and_call_original
        Hey.publish!(event_name, { foo: "baz" } )
      end
    end
  end
end
