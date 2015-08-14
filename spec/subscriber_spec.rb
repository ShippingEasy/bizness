require "spec_helper"

describe Bizness::Subscriber do
  let!(:widget) { Widget.create(name: "Foo") }
  let(:event_name) { "cancel_account:succeeded" }

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
        Hey.publish!(event_name, { widget_id: widget.id } )
        expect(Widget.last.name).to eq("Boo")
      end
    end

    context "when not configured with a block" do
      before do
        MockDataOperation2.extend(Bizness::Subscriber)
        MockDataOperation2.subscribe(event_name)
      end

      it "executes the operation if the subscribed event is broadcasted" do
        Hey.publish!(event_name, { widget_id: widget.id } )
        expect(Widget.last.name).to eq("Boo")
      end
    end
  end
end
