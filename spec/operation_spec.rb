require "spec_helper"

describe Bizness::Operation do
  subject { MockOperation.new(foo: "bar") }

  before do
    Bizness.configure do |config|
      config.filters = [Bizness::Filters::EventFilter]
    end
  end

  describe ".call!" do
    it "executes a filtered operation" do
      expect(Bizness).to receive(:run).with(subject)
      subject.call!
    end

    it "calls the object's custom business logic" do
      expect(subject).to receive(:call)
      subject.call!
    end

    it "sets an error if unsuccessful" do
      allow(subject).to receive(:call).and_raise("Oops")
      subject.call!
      expect(subject.error).to eq("Oops")
    end
  end

  describe "#successful?" do
    context "when error is set" do
      it "returns false" do
        allow(subject).to receive(:call).and_raise("Oops")
        subject.call!
        expect(subject).to_not be_successful
      end
    end

    context "when error is not set" do
      it "returns false" do
        subject.call!
        expect(subject).to be_successful
      end
    end
  end
end
