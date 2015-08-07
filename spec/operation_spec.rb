require "spec_helper"

describe Bizness::Operation do
  subject { MockOperation.new }

  before do
    Bizness.configure do |config|
      config.filters = [Bizness::Filters::EventFilter]
    end
  end

  describe "#context" do
    context "when object is initialized with a hash" do
      it "converts it into a context" do
        expect(subject.context).to be_a(Bizness::Context)
      end
    end

    context "when object is initialized with a context" do
      it "returns the context" do
        context = Bizness::Context.new
        expect(Bizness::Operation.new(context).context).to eq(context)
      end
    end
  end

  describe ".filters" do
    it "delegates to the configuration's filters" do
      expect(Bizness::Operation.filters).to eq(Bizness.filters)
    end
  end

  describe ".call!" do
    it "executes a filtered operation" do
      expect_any_instance_of(Bizness::Filters::EventFilter).to receive(:call)
      subject.call!
    end

    it "executes the custom business logic" do
      expect(subject).to receive(:call)
      subject.call!
    end

    it "sets an error if unsuccessful" do
      subject.fail!(error: "Oops")
      subject.call!
      expect(subject.error).to eq("Oops")
    end
  end

  describe "#fail!" do
    it "sets the error message on the context" do
      subject.fail!(error: "Oops")
      expect(subject.context.error).to eq("Oops")
    end
  end

  describe "#successful?" do
    context "when error is set" do
      it "returns false" do
        subject.fail!(error: "Oops")
        expect(subject).to_not be_successful
      end
    end

    context "when error is not set" do
      it "returns false" do
        expect(subject).to be_successful
      end
    end
  end
end
