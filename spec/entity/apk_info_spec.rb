# frozen_string_literal: true

require_relative "../spec_helper"

module Apkstats::Entity
  describe Apkstats::Entity::ApkInfo do
    let(:command_values) do
      {
          file_size: 100,
          download_size: 150,
          required_features: Features.new([
                                            Feature.new("feature1"),
                                            Feature.new("feature2"),
                                          ]),
          non_required_features: Features.new([
                                                Feature.new("feature3", not_required: true),
                                                Feature.new("feature4", not_required: true),
                                              ]),
          permissions: Permissions.new([
                                         Permission.new("permission1"),
                                         Permission.new("permission2", max_sdk: "23"),
                                       ]),
          min_sdk: "16",
          target_sdk: "26",
          method_reference_count: 20_000,
          dex_count: 1,
      }
    end

    let(:command) { Apkstats::Stub::Command.new(command_values) }

    it "precondition for this spec" do
      expect(command_values).to include(*ApkInfo::KEYS)
    end

    it "read values of a command" do
      apk_info = ApkInfo.new(command, "apk filepath")

      ApkInfo::KEYS.each do |key|
        expect(apk_info.send(key)).to eq(command_values[key])
        expect(apk_info[key]).to eq(command_values[key])
      end
    end

    it "to_h" do
      apk_info = ApkInfo.new(command, "apk filepath")

      expect(apk_info.to_h).to include(command_values)
    end
  end
end
