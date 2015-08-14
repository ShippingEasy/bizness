require "spec_helper"

describe Bizness::Filters::ActiveRecordTransactionFilter do
  it "commits the transaction" do
    op = MockOperation.new(foo: "bar")
    allow(op).to receive(:call) { Widget.new.save! }
    filter = Bizness::Filters::ActiveRecordTransactionFilter.new(op)
    filter.call
    expect(Widget.count).to eq(1)
  end

  context "when failed" do
    it "rolls back the transaction" do
      op = MockOperation.new(foo: "bar")
      allow(op).to receive(:call).and_raise("Oops")
      filter = Bizness::Filters::ActiveRecordTransactionFilter.new(op)
      begin; filter.call; rescue; end
      expect(Widget.all).to be_empty
    end
  end
end
