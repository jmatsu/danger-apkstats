# frozen_string_literal: true

require_relative "../spec_helper"

module Apkstats::Entity
  describe Apkstats::Entity::Features do
    def create_feature(name, opts = {})
      Feature.new(name, not_required: opts[:not_required], implied_reason: opts[:implied_reason])
    end

    let(:feature1) { create_feature("feature1") }
    let(:feature2) { create_feature("feature2", not_required: true) }
    let(:feature3) { create_feature("feature3", implied_reason: "due to tests") }

    context "-" do
      it "should remove elements by name and not_required" do
        one_two_three = Features.new([feature1, feature2, feature3])
        one_two = Features.new([feature1, feature2])

        expect((one_two_three - one_two).values).to contain_exactly(feature3)

        new_feature2 = create_feature(feature2.name, not_required: !feature2.not_required?)
        expect((one_two - Features.new([new_feature2])).values).to contain_exactly(feature1, feature2)

        new_feature3 = create_feature(feature3.name, implied_reason: nil)
        expect((one_two_three - Features.new([new_feature3])).values).to contain_exactly(feature1, feature2)
      end
    end

    context "to_a" do
      it "should return an array of stringified elements" do
        one_two_three = Features.new([feature1, feature2, feature3])

        expect(one_two_three.to_a).to contain_exactly(
          feature1.to_s,
          feature2.to_s,
          feature3.to_s
        )
      end
    end
  end
end
