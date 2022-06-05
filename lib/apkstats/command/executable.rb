# frozen_string_literal: true

module Apkstats::Command
  # @!attribute [r] command_path
  #   @return [String] a path to a command
  module Executable
    require "open3"

    attr_reader :command_path

    # @return [Boolean] returns true if the command_path is executable, otherwise false.
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
      base = Apkstats::Entity::ApkInfo.new(command: self, apk_filepath: apk_filepath)
      other = Apkstats::Entity::ApkInfo.new(command: self, apk_filepath: other_apk_filepath)

      Apkstats::Entity::ApkInfoDiff.new(base: base, other: other).to_h
    end
  end
end
