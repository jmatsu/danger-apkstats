# frozen_string_literal: true

require_relative "../spec_helper"

module Apkstats::Entity
  describe Apkstats::Entity::ApkInfoDiff do
    def create_feature(name, opts = {})
      Feature.new(name, not_required: opts[:not_required], implied_reason: opts[:implied_reason])
    end

    def create_permission(name, opts = {})
      Permission.new(name, max_sdk: opts[:max_sdk])
    end

    let(:base_apk_values) do
      {
          file_size: 100,
          download_size: 150,
          required_features: Features.new([
                                            create_feature("feature1"),
                                            create_feature("feature2"),
                                            create_feature("feature3", implied_reason: "implied_reason"),
                                          ]),
          non_required_features: Features.new([
                                                create_feature("feature_1", not_required: true),
                                                create_feature("feature_2", not_required: true),
                                              ]),
          permissions: Permissions.new([
                                         create_permission("permission1"),
                                         create_permission("permission2", max_sdk: "23"),
                                       ]),
          min_sdk: "16",
          target_sdk: "26",
          method_reference_count: 20_000,
          dex_count: 1,
      }
    end

    let(:other_apk_values) do
      {
          file_size: base_apk_values[:file_size] + 500,
          download_size: base_apk_values[:download_size] - 100,
          required_features: Features.new([
                                            create_feature("feature1"),
                                            create_feature("feature3"), # ignored
                                            create_feature("feature4"),
                                            # create_feature("feature2")
                                          ]),
          non_required_features: Features.new([
                                                create_feature("feature_1", not_required: true),
                                                create_feature("feature_3", not_required: true),
                                                # create_feature("feature_2", not_required: true),
                                              ]),
          permissions: Permissions.new([
                                         create_permission("permission1", max_sdk: "24"),
                                         create_permission("permission2"),
                                         # create_permission("permission1"),
                                         # create_permission("permission2", "23"),
                                       ]),
          min_sdk: "21",
          target_sdk: "27",
          method_reference_count: base_apk_values[:method_reference_count] + 2000,
          dex_count: base_apk_values[:dex_count] + 1,
      }
    end

    let(:base_command) { Apkstats::Stub::Command.new(base_apk_values) }
    let(:other_command) { Apkstats::Stub::Command.new(other_apk_values) }

    it "precondition for this spec" do
      expect(base_apk_values).to include(*ApkInfo::KEYS)
      expect(other_apk_values).to include(*ApkInfo::KEYS)
    end

    it "read values of a command" do
      base_apk_info = ApkInfo.new(base_command, "apk filepath")
      other_apk_info = ApkInfo.new(other_command, "apk filepath")

      diff = ApkInfoDiff.new(base_apk_info, other_apk_info)

      expect(diff.file_size).to eq(-500)
      expect(diff.download_size).to eq(100)
      expect(diff.required_features).to include(
        new: Features.new([
                            create_feature("feature2"),
                          ]).to_a,
        removed: Features.new([
                                create_feature("feature4"),

                              ]).to_a
      )
      expect(diff.non_required_features).to include(
        new: Features.new([
                            create_feature("feature_2", not_required: true),
                          ]).to_a,
        removed: Features.new([
                                create_feature("feature_3", not_required: true)
                              ]).to_a
      )
      expect(diff.permissions).to include(
        new: Permissions.new([
                               create_permission("permission1"),
                               create_permission("permission2", max_sdk: "23"),
                             ]).to_a,
        removed: Permissions.new([
                                   create_permission("permission1", max_sdk: "24"),
                                   create_permission("permission2"),
                                 ]).to_a
      )
      expect(diff.min_sdk).to eq(%w(16 21))
      expect(diff.target_sdk).to eq(%w(26 27))
      expect(diff.method_reference_count).to eq(-2000)
      expect(diff.dex_count).to eq(-1)
    end
  end
end
