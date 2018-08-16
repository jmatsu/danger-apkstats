# frozen_string_literal: true

module Apkstats::Command
  class ApkAnalyzer
    include Apkstats::Command::Executable

    def initialize(opts)
      @command_path = opts[:command_path] || "#{ENV.fetch('ANDROID_HOME')}/tools/bin/apkanalyzer"
    end

    def file_size(apk_filepath)
      run_command("apk", "file-size", apk_filepath)
    end

    def download_size(apk_filepath)
      run_command("apk", "download-size", apk_filepath)
    end

    def required_features(apk_filepath)
      ::Apkstats::Entity::Features.new(ApkAnalyzer.parse_features(run_command("apk", "features", apk_filepath)))
    end

    def non_required_features(apk_filepath)
      all_features = ApkAnalyzer.parse_features(run_command("apk", "features", "--not-required", apk_filepath))
      Apkstats::Entity::Features.new(all_features.select(&:not_required?))
    end

    def permissions(apk_filepath)
      ::Apkstats::Entity::Permissions.new(ApkAnalyzer.parse_permissions(run_command("manifest", "permissions", apk_filepath)))
    end

    def min_sdk(apk_filepath)
      run_command("manifest", "min-sdk", apk_filepath)
    end

    def target_sdk(apk_filepath)
      run_command("manifest", "target-sdk", apk_filepath)
    end

    def method_reference_count(apk_filepath)
      ApkAnalyzer.parse_reference_to_map(run_command("dex", "references", apk_filepath))
        .values
        .map(&:to_i)
        .inject(:+)
    end

    def dex_count(apk_filepath)
      ApkAnalyzer.parse_reference_to_map(run_command("dex", "references", apk_filepath)).size
    end

    def self.parse_permissions(command_output)
      command_output.split(/\r?\n/).map { |s| to_permission(s) }
    end

    def self.to_permission(str)
      # If maxSdkVersion is specified, the output is like `android.permission.INTERNET' maxSdkVersion='23`
      name_seed, max_sdk_seed = str.strip.split(/\s/)
      ::Apkstats::Entity::Permission.new(name_seed.gsub(/'$/, ""), max_sdk: max_sdk_seed && max_sdk_seed[/[0-9]+/])
    end

    def self.parse_features(command_output)
      command_output.split(/\r?\n/).map { |s| to_feature(s) }
    end

    def self.to_feature(str)
      # format / name implied: xxxx
      # not-required and implied cannot co-exist so it's okay to parse them like this
      name, kind, tail = str.strip.split(/\s/, 3)

      ::Apkstats::Entity::Feature.new(name, not_required: kind == "not-required", implied_reason: kind == "implied:" && tail)
    end

    def self.parse_reference_to_map(command_output)
      command_output.split(/\r?\n/).each_with_object({}) do |s, acc|
        dex_file, method_count = s.strip.split(/\t/, 2)
        acc[dex_file] = method_count
      end
    end

    private

    def run_command(*args)
      out, err, status = Open3.capture3("#{command_path} #{args.join(' ')}")
      raise err unless status.success?
      out.rstrip
    end
  end
end
