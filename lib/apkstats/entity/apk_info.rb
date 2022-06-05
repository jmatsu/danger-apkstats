# frozen_string_literal: true

module Apkstats::Entity
  class ApkInfo
    KEYS = %i(
      file_size
      download_size
      required_features
      non_required_features
      permissions
      min_sdk
      target_sdk
      method_reference_count
      dex_count
    ).freeze

    # Integer
    attr_accessor :file_size, :download_size, :method_reference_count, :dex_count

    # String
    attr_accessor :min_sdk, :target_sdk

    # Array<String>
    attr_accessor :required_features, :non_required_features, :permissions

    # @param command [Apkstats::Command::Executable] a command to execute
    # @param apk_filepath [String, Pathname] a path to a apk file
    def initialize(command:, apk_filepath:)
      apk_filepath = apk_filepath.kind_of?(Pathname) ? apk_filepath.to_s : apk_filepath

      KEYS.each do |key|
        self.send("#{key}=", command.send(key, apk_filepath))
      end
    end

    def [](key)
      send(key)
    end

    def to_h
      KEYS.each_with_object({}) do |key, acc|
        acc[key] = self[key]
      end
    end
  end
end
