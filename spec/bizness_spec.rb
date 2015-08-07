require "spec_helper"

describe Bizness do
  describe ".filters" do
    it "delegates to the configuration" do
      expect(Bizness.filters).to eq(Bizness.configuration.filters)
    end
  end
end
