# frozen_string_literal: true

require_relative "../spec_helper"

module Apkstats::Entity
  describe Apkstats::Entity::Permissions do
    def create_permission(name, opts = {})
      Permission.new(name, max_sdk: opts[:max_sdk])
    end

    let(:permission1) { create_permission("permission1") }
    let(:permission2) { create_permission("permission2", max_sdk: "24") }

    context "-" do
      it "should remove elements by name and max_sdk" do
        one = Permissions.new([permission1])
        one_two = Permissions.new([permission1, permission2])

        expect((one_two - one).values).to contain_exactly(permission2)

        new_permission2 = create_permission(permission2.name, max_sdk: "12")
        expect((one_two - Permissions.new([new_permission2])).values).to contain_exactly(permission1, permission2)
      end
    end

    context "to_a" do
      it "should return an array of stringified elements" do
        one_two = Permissions.new([permission1, permission2])

        expect(one_two.to_a).to contain_exactly(
          permission1.to_s,
          permission2.to_s
        )
      end
    end
  end
end
