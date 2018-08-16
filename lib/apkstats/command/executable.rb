# frozen_string_literal: true

module Apkstats::Command
  module Executable
    require "open3"

    attr_reader :command_path

    def executable?
      File.executable?(command_path)
    end

    # Compare two apk files and return results.
    #
    # {
    #   base: {
    #     file_size: Integer,
    #     download_size: Integer,
    #     required_features: Array<String>,
    #     non_required_features: Array<String>,
    #     permissions: Array<String>,
    #     min_sdk: String,
    #     target_sdk: String,
    #     method_reference_count: Integer,
    #     dex_count: Integer,
    #   },
    #   other: {
    #     file_size: Integer,
    #     download_size: Integer,
    #     required_features: Array<String>,
    #     non_required_features: Array<String>,
    #     permissions: Array<String>,
    #     min_sdk: String,
    #     target_sdk: String,
    #     method_reference_count: Integer,
    #     dex_count: Integer,
    #   },
    #   diff: {
    #     file_size: Integer,
    #     download_size: Integer,
    #     required_features: {
    #       new: Array<String>,
    #       removed: Array<String>,
    #     },
    #     non_required_features:{
    #       new: Array<String>,
    #       removed: Array<String>,
    #     },
    #     permissions: {
    #       new: Array<String>,
    #       removed: Array<String>,
    #     },
    #     min_sdk: Array<String>,
    #     target_sdk: Array<String>,
    #     method_reference_count: Integer,
    #     dex_count: Integer,
    #   }
    # }
    #
    # @return [Hash]
    def compare_with(apk_filepath, other_apk_filepath)
      base = Apkstats::Entity::ApkInfo.new(self, apk_filepath)
      other = Apkstats::Entity::ApkInfo.new(self, other_apk_filepath)

      Apkstats::Entity::ApkInfoDiff.new(base, other).to_h
    end
  end
end
