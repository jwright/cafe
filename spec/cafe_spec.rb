# frozen_string_literal: true

RSpec.describe Cafe do
  it "has a version number" do
    expect(Cafe::VERSION).not_to be nil
  end

  describe "#calculate_revenue" do
    subject(:revenue) { Cafe::Revenue.new }

    context "with no sessions" do
      it "returns 0" do
        expect(revenue.calculate([])).to eq(0)
      end
    end

    context "with one hourly rate" do
      let(:session) { [1, 9, 1] }

      it "returns the revenue for one hour" do
        expect(revenue.calculate([session])).to eq(2)
      end
    end

    context "with multiple hourly rates" do
      let(:session) { [1, 9, 2] }

      it "returns the revenue for multiple rates" do
        expect(revenue.calculate([session])).to eq(6)
      end
    end

    it "returns the correct calculations" do
      expect(revenue.calculate([[1, 8, 2]])).to eq(4)
      expect(revenue.calculate([[3, 14, 1], [4, 10, 3], [1, 9, 9]])).to eq(85)
    end
  end
end
