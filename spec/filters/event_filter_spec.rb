require "spec_helper"

describe Bizness::Filters::EventFilter do
  let(:op) { op = MockOperation.new(foo: "bar") }
  subject(:filter) { Bizness::Filters::EventFilter.new(op) }

  it "publishes an executed event" do
    expect(Hey).to receive(:publish!).with("mock_operation:executed", {foo: "bar"})
    filter.call
  end

  context "when succeeded" do
    before do
      allow(op).to receive(:successful?).and_return(true)
    end

    it "publishes a succeeded event" do
      expect(Hey).to receive(:publish!).once.with("mock_operation:executed", {foo: "bar"}).and_call_original
      expect(Hey).to receive(:publish!).once.with("mock_operation:succeeded", {foo: "bar", custom_message: "Operation completed"})
      filter.call
    end

    it "propagates the return value of the operation" do
      expect(filter.call).to eq("MOCK RETURN VALUE")
    end
  end

  context "when failed" do
    before do
      allow(op).to receive(:successful?).and_return(false)
    end

    it "publishes a failed event" do
      expect(Hey).to receive(:publish!).once.with("mock_operation:executed", {foo: "bar"}).and_call_original
      expect(Hey).to receive(:publish!).once.with("mock_operation:failed", hash_including({foo: "bar"}))
      filter.call
    end

    it "propagates the return value of the operation" do
      expect(filter.call).to eq("MOCK RETURN VALUE")
    end
  end

  context "when aborted" do
    before do
      allow(op).to receive(:call).and_raise("Oops")
    end

    it "publishes a aborted event" do
      expect(Hey).to receive(:publish!).once.with("mock_operation:executed", {foo: "bar"}).and_call_original
      expect(Hey).to receive(:publish!).once.with("mock_operation:aborted", hash_including(foo: "bar", error: "Oops"))
      expect { filter.call }.to raise_error("Oops")
    end
  end
end
