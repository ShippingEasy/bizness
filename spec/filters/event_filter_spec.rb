require "spec_helper"

describe Bizness::Filters::EventFilter do
  it "publishes an executed event" do
    op = MockOperation.new(foo: "bar")
    filter = Bizness::Filters::EventFilter.new(op)
    expect(Hey).to receive(:publish!).with("mock_operation:executed", {foo: "bar"})
    filter.call
  end

  context "when successful" do
    it "publishes a successful event" do
      op = MockOperation.new(foo: "bar")
      filter = Bizness::Filters::EventFilter.new(op)
      expect(Hey).to receive(:publish!).once.with("mock_operation:executed", {foo: "bar"}).and_call_original
      expect(Hey).to receive(:publish!).once.with("mock_operation:succeeded", {foo: "bar", custom_message: "Operation completed"})
      filter.call
    end
  end

  context "when failed" do
    it "publishes a failed event" do
      op = MockOperation.new(foo: "bar")
      allow(op).to receive(:call).and_raise("Oops")
      filter = Bizness::Filters::EventFilter.new(op)
      expect(Hey).to receive(:publish!).once.with("mock_operation:executed", {foo: "bar"}).and_call_original
      expect(Hey).to receive(:publish!).once.with("mock_operation:failed", {foo: "bar", error: "Oops"})
      expect { filter.call }.to raise_error("Oops")
    end
  end
end
