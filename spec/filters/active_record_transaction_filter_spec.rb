require "spec_helper"

describe Bizness::Filters::ActiveRecordTransactionFilter do
  let(:op) { op = MockOperation.new(foo: "bar") }

  context "when successful" do
    subject(:filter) {  Bizness::Filters::ActiveRecordTransactionFilter.new(op) }
    before do
      allow(op).to receive(:call) { Widget.new.save!; "RETURN VALUE" }
    end

    it "commits the transaction" do
      filter.call
      expect(Widget.count).to eq(1)
    end

    it "propagates the return value" do
      expect(filter.call).to eq("RETURN VALUE")
    end
  end

  context "when failed" do
    it "rolls back the transaction and propagates the exception" do
      allow(op).to receive(:call).and_raise("Oops")
      filter = Bizness::Filters::ActiveRecordTransactionFilter.new(op)
      expect{ filter.call }.to raise_error(/Oops/)
      expect(Widget.all).to be_empty
    end
  end
end
