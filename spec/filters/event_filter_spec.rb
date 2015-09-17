require "spec_helper"

describe Bizness::Filters::EventFilter do
  it "publishes an executed event" do
    op = MockOperation.new(foo: "bar")
    filter = Bizness::Filters::EventFilter.new(op)
    expect(Hey).to receive(:publish!).with("executed", {foo: "bar"})
    filter.call
  end

  context "when successful" do
    it "publishes a successful event" do
      op = MockOperation.new(foo: "bar")
      filter = Bizness::Filters::EventFilter.new(op)
      expect(Hey).to receive(:publish!).once.with("executed", {foo: "bar"}).and_call_original
      expect(Hey).to receive(:publish!).once.with("succeeded", {foo: "bar", custom_message: "Operation completed"})
      filter.call
    end
  end

  context "when failed" do
    it "re-raises the error" do
      op = MockOperation.new(foo: "bar")
      allow(op).to receive(:call).and_raise("Oops")
      filter = Bizness::Filters::EventFilter.new(op)
      expect(Hey).to receive(:publish!).once.with("executed", {foo: "bar"}).and_call_original
      expect(Hey).to receive(:publish!)
      expect { filter.call }.to raise_error("Oops")
    end
  end
end
