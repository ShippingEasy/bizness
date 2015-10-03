require "spec_helper"

describe Bizness::Policy do
  let(:string) { "Bar!" }

  subject { Mocks::MockPolicy.new(foo: string) }

  describe "#obeyed?, #violated?" do
    context "when all predicates pass" do
      let(:string) { "BAR" }

      it "is obeyed?" do
        expect(subject).to be_obeyed
      end

      it "is not violated?" do
        expect(subject).to_not be_violated
      end

      it "has no violations" do
        expect(subject.violations).to be_empty
      end
    end

    context "when a predicate fails" do
      it "adds a violation messages" do
        subject.obeyed?
        expect(subject.violations).to match_array(["String must be alphanumeric", "Characters must be all uppercase"])
      end

      it "is not obeyed" do
        expect(subject).to_not be_obeyed
      end

      it "is violated" do
        expect(subject).to be_violated
      end
    end
  end

  describe "#__requirements__" do
    it "returns a list of predicate methods" do
      expect(Mocks::MockPolicy.__requirements__).to match_array([:alphanumeric?, :all_caps?])
    end
  end
end
