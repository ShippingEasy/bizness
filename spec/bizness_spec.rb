require "spec_helper"

describe Bizness do
  let(:operation) { MockOperation.new(foo: "bar") }

  before do
    Bizness.configure do |config|
      config.filters = [Bizness::Filters::EventFilter]
    end
  end

  describe ".filters" do
    it "delegates to the configuration" do
      expect(Bizness.filters).to eq(Bizness.configuration.filters)
    end
  end

  describe ".run" do
    context "when object is passed in" do
      it "executes a filtered operation" do
        expect_any_instance_of(Bizness::Filters::EventFilter).to receive(:call)
        Bizness.run(operation)
      end

      it "calls the operation custom logic" do
        expect(operation).to receive(:call)
        Bizness.run(operation)
      end
    end

    context "when block is passed in" do
      it "executes the block as a filtered operation" do
        expect_any_instance_of(Bizness::Filters::EventFilter).to receive(:call)
        Bizness.run do
          @foo = "bar"
        end
      end
    end
  end
end
