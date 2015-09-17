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

  describe "#successful?, #aborted" do
    context "when error is set" do
      before do
        allow(subject).to receive(:call).and_raise("Oops")
        subject.call!
      end

      it "is not successful" do
        expect(subject).to_not be_successful
      end

      it "is aborted" do
        expect(subject).to be_aborted
      end
    end

    context "when error is not set" do
      before do
        subject.call!
      end

      it "is successful" do
        expect(subject).to be_successful
      end

      it "is not aborted" do
        expect(subject).to_not be_aborted
      end
    end
  end
end
