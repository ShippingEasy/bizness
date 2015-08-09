require "spec_helper"

describe Bizness::Context do
  subject { Bizness::Context.new }

  describe "#succesful?" do
    context "when error is empty" do
      it "returns true" do
        subject.error = nil
        expect(subject).to be_successful
      end
    end

    context "when error is set" do
      it "returns false" do
        subject.error = "Oops"
        expect(subject).to_not be_successful
      end
    end
  end

  describe "#to_h" do
    it "includes id attributes for object's that respond to #id" do
      subject.widget = Widget.create
      expect(subject.to_h[:widget]).to eq(subject.widget)
      expect(subject.to_h[:widget_id]).to eq(subject.widget.id)
    end
  end
end
