require "spec_helper"

describe Bizness::Policy do
  let(:string) { "Bar!" }

  subject { Mocks::MockPolicy.new(foo: string) }

  describe "#successful?" do
    context "when all predicates pass" do
      let(:string) { "BAR" }

      it "is successful?" do
        expect(subject).to be_successful
      end

      it "has no violations" do
        expect(subject.violations).to be_empty
      end
    end

    context "when a predicate fails" do
      it "adds a violation messages" do
        subject.successful?
        expect(subject.violations).to match_array(["String must be alphanumeric", "Characters must be all uppercase"])
      end

      it "is not successful" do
        expect(subject).to_not be_successful
      end
    end
  end

  describe "#__requirements__" do
    it "returns a list of predicate methods" do
      expect(Mocks::MockPolicy.__requirements__).to match_array([:alphanumeric?, :all_caps?])
    end
  end
end
