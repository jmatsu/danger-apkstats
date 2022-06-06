module Apkstats::Reporter

  # @!attribute [r] apk_info
  #   @return [Apkstats::Entity::ApkInfo]
  class ApkSummary
    LABELS = {
      file_size: "File Size",
      download_size: "Download File Size",
      required_features: "Required Features",
      non_required_features: "Non-required Features",
      permissions: "Permissions",
      min_sdk: "Min Sdk",
      target_sdk: "Target Sdk",
      method_reference_count: "Method Reference Count",
      dex_count: "Dex File Count"
    }

    attr_reader :apk_info

    def initialize(apk_info:)
      @apk_info = apk_info
    end

    # @return [String] markdown text
    def generate_markdown
      lines = []
      lines << "### Apk summary\n"
      lines << "Property | Value"
      lines << ":--- | :---"

      lines << apk_info.to_h.map do |key, value|
        text =
          case value
          when Array
            value.map { |item| "- #{item}" }.join("<br>")
          when Apkstats::Entity::Features
            if value.values.empty?
              "N/A"
            else
              value.values.map { |f| "- #{f}" }.join("<br>")
            end
          when Apkstats::Entity::Permissions
            if value.values.empty?
              "N/A"
            else
              value.values.map { |f| "- #{f}" }.join("<br>")
            end
          else
            value
          end

        "#{LABELS[key]} | #{text}"
      end

      lines.join("\n")
    end
  end
end