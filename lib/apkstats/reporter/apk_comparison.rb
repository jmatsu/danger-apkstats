# frozen_string_literal: true

module Apkstats::Reporter
  # @!attribute [r] base_apk_info
  #   @return [Apkstats::Entity::ApkInfo]
  # @!attribute [r] other_apk_info
  #   @return [Apkstats::Entity::ApkInfo]
  # @!attribute [r] diff_apk_info
  #   @return [Apkstats::Entity::ApkInfoDiff]
  class ApkComparison
    attr_reader :base_apk_info, :other_apk_info, :diff_apk_info

    # @param base_apk_info [Apkstats::Entity::ApkInfo] an apk info
    # @param other_apk_info [Apkstats::Entity::ApkInfo] an apk info
    def initialize(base_apk_info:, other_apk_info:)
      @base_apk_info = base_apk_info
      @other_apk_info = other_apk_info
      @diff_apk_info = Apkstats::Entity::ApkInfoDiff.new(base: base_apk_info, other: other_apk_info)
    end

    # rubocop:disable Metrics/AbcSize

    # @return [String] markdown text
    def generate_markdown
      base = base_apk_info.to_h
      diff = diff_apk_info.to_h

      lines = []
      lines << "### Apk comparison results\n"
      lines << "Property | Summary"
      lines << ":--- | :---"

      diff[:min_sdk].tap do |min_sdk|
        lines << min_sdk_change(before_value: min_sdk[1], after_value: min_sdk[0])
      end

      diff[:target_sdk].tap do |target_sdk|
        lines << target_sdk_change(before_value: target_sdk[1], after_value: target_sdk[0])
      end

      base[:file_size].tap do |file_size|
        lines << new_file_size(size_in_bytes: file_size)
      end

      diff[:file_size].tap do |file_size|
        lines << file_size_change(size_in_bytes: file_size)
      end

      diff[:download_size].tap do |download_size|
        lines << download_size_change(size_in_bytes: download_size)
      end

      base[:method_reference_count].tap do |method_reference_count|
        lines << new_method_reference_count(value: method_reference_count)
      end

      diff[:method_reference_count].tap do |method_reference_count|
        lines << method_reference_count_change(value: method_reference_count)
      end

      base[:dex_count].tap do |dex_count|
        lines << new_dex_file_count(value: dex_count)
      end

      diff[:dex_count].tap do |dex_count|
        lines << dex_file_count_change(value: dex_count)
      end

      lines << itemize_values_diff(name: "Required Features", diff: diff[:required_features])
      lines << itemize_values_diff(name: "Non-required Features", diff: diff[:non_required_features])
      lines << itemize_values_diff(name: "Permissions", diff: diff[:permissions])

      lines.flatten.join("\n") << "\n" # \n is required for the backward compatibility
    end

    # rubocop:enable Metrics/AbcSize

    def min_sdk_change(before_value:, after_value:)
      return [] if before_value.nil? || after_value.nil?

      "Min SDK Change | Before #{before_value} / After #{after_value}"
    end

    def target_sdk_change(before_value:, after_value:)
      return [] if before_value.nil? || after_value.nil?

      "Target SDK Change | Before #{before_value} / After #{after_value}"
    end

    def new_file_size(size_in_bytes:)
      sizer = Apkstats::Helper::Bytes.from_b(size_in_bytes)
      "New File Size | #{sizer.to_b} Bytes. (#{sizer.to_mb} MB) "
    end

    def file_size_change(size_in_bytes:)
      sizer = Apkstats::Helper::Bytes.from_b(size_in_bytes)
      "File Size Change | #{sizer.to_s_b} Bytes. (#{sizer.to_s_kb} KB) "
    end

    def download_size_change(size_in_bytes:)
      sizer = Apkstats::Helper::Bytes.from_b(size_in_bytes)
      "Download Size Change | #{sizer.to_s_b} Bytes. (#{sizer.to_s_kb} KB) "
    end

    def new_method_reference_count(value:)
      "New Method Reference Count | #{value}"
    end

    def method_reference_count_change(value:)
      "Method Reference Count Change | #{value}"
    end

    def new_dex_file_count(value:)
      "New Number of dex file(s) | #{value}"
    end

    def dex_file_count_change(value:)
      "Number of dex file(s) Change | #{value}"
    end

    def itemize_values_diff(name:, diff:)
      [itemize_with_label(label: "New #{name}", items: diff[:new]), itemize_with_label(label: "Removed #{name}", items: diff[:removed])]
    end

    private

    def itemize_with_label(label:, items:)
      return [] if items.empty?

      "#{label} | #{items.map { |item| "- #{item}" }.join('<br>')}"
    end
  end
end
