# frozen_string_literal: true

require_relative "gem_version"
require_relative "helper/bytes"

require_relative "entity/apk_info"
require_relative "entity/apk_info_diff"
require_relative "entity/feature"
require_relative "entity/permission"

require_relative "command/executable"
require_relative "command/apk_analyzer"

require_relative "reporter/apk_comparison"
require_relative "reporter/apk_summary"

module Danger
  # Show stats of your apk file.
  # By default, it's done using apkanalyzer in android sdk.
  #
  # All command need your apk filepath like below
  #
  #         apkstats.apk_filepath=<your new apk filepath>
  #
  # @example Compare two apk files and print it.
  #
  #         apkstats.compare_with(<your old apk filepath>, do_report: true) # report it in markdown table
  #         apkstats.compare_with(<your old apk filepath>, do_report: false) # just return results
  #
  # @example Show the file size of your apk file.
  #
  #         apkstats.file_size
  #
  # @example Show the download size of your apk file.
  #
  #         apkstats.download_size
  #
  # @example Show all required features of your apk file.
  #
  #         apkstats.required_features
  #
  # @example Show all non-required features of your apk file.
  #
  #         apkstats.non_required_features
  #
  # @example Show all requested permissions of your apk file.
  #
  #         apkstats.permissions
  #
  # @example Show the min sdk version of your apk file.
  #
  #         apkstats.min_sdk
  #
  # @example Show the target sdk version of your apk file.
  #
  #         apkstats.target_sdk
  #
  # @example Show the methods reference count of your apk file.
  #
  #         apkstats.method_reference_count
  #
  # @example Show the number of dex of your apk file.
  #
  #         apkstats.dex_count
  #
  # @see  Jumpei Matsuda/danger-apkstats
  # @tags android, apk_stats
  #
  class DangerApkstats < Plugin
    class Error < StandardError; end

    # @deprecated this field have no effect
    COMMAND_TYPE_MAP = {
      apk_analyzer: Apkstats::Command::ApkAnalyzer,
    }.freeze

    private_constant(:COMMAND_TYPE_MAP)

    # @deprecated this field have no effect
    # This will be removed in further versions
    #
    # @return [String] _
    attr_accessor :command_type

    # *Required*
    #
    # @param value [String, Pathname] A path of apkanalyzer command
    # @return [String]
    def apkanalyzer_path=(value)
      @apkanalyzer_path = value.to_s
    end

    # @return [String, NilClass] A path of apkanalyzer command
    attr_reader :apkanalyzer_path

    # Use apkanalyzer_path instead
    #
    # @deprecated
    # @return [String] _
    alias command_path apkanalyzer_path

    # Use apkanalyzer_path= instead
    #
    # @deprecated
    # @return [String, Pathname] _
    alias command_path= apkanalyzer_path=

    # *Required*
    # @param value [String, Pathname] Your base apk filepath.
    # @return [String]
    def apk_filepath=(value)
      @apk_filepath = value.to_s
    end

    # @return [String, NilClass] Your base apk filepath.
    attr_reader :apk_filepath

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

    # Get stats of two apk files and calculate diffs between them.
    #
    # @param [String, Pathname] other_apk_filepath your old apk
    # @param [Boolean] do_report Deprecated. report markdown table if true, otherwise just return results.
    # @return [Hash] Deprecated. If you would like to get the comparison results in Hash, then please use calculate_diff instead.
    def compare_with(other_apk_filepath, do_report: true)
      ensure_apk_filepath!

      process do
        if do_report
          reporter = Apkstats::Reporter::ApkComparison.new(
            base_apk_info: Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: apk_filepath),
            other_apk_info: Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: other_apk_filepath)
          )

          markdown(reporter.generate_markdown)
          true
        else
          calculate_diff(other_apk_filepath: other_apk_filepath)
        end
      end
    end

    # Report the summary of the single apk.
    #
    # @return [void]
    def summary
      ensure_apk_filepath!

      process do
        reporter = Apkstats::Reporter::ApkSummary.new(
          apk_info: Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: apk_filepath)
        )

        markdown(reporter.generate_markdown)
      end
    end

    # Calculate the differences of apk_filepath and the given apk file and returns them.
    #
    # @param other_apk_filepath [String, Pathname] an apk file path to be compared.
    # @return [Hash] a Hash contains the differences
    def calculate_diff(other_apk_filepath:)
      ensure_apk_filepath!

      base_apk_info = Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: apk_filepath),
      other_apk_info = Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: other_apk_filepath)
      diff_apk_info = Apkstats::Entity::ApkInfoDiff.new(base: base_apk_info, other: other_apk_info)

      {
        base: base_apk_info.to_h,
        other: other_apk_info.to_h,
        diff: diff_apk_info.to_h
      }
    end

    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # Show the file size of your apk file.
    #
    # @return [Fixnum] return positive value if exists, otherwise -1.
    def file_size(_opts = {})
      result = run_command(apkanalyzer_command, __method__)
      result ? result.to_i : -1
    end

    # Show the download size of your apk file.
    #
    # @return [Fixnum] return positive value if exists, otherwise -1.
    def download_size(_opts = {})
      result = run_command(apkanalyzer_command, __method__)
      result ? result.to_i : -1
    end

    # Show all required features of your apk file.
    # The result doesn't contain non-required features.
    #
    # @return [Array<String>, Nil] return nil unless retrieved.
    def required_features(_opts = {})
      result = run_command(apkanalyzer_command, __method__)
      result ? result.to_a : nil
    end

    # Show all non-required features of your apk file.
    # The result doesn't contain required features.
    #
    # @return [Array<String>, Nil] return nil unless retrieved.
    def non_required_features(_opts = {})
      result = run_command(apkanalyzer_command, __method__)
      result ? result.to_a : nil
    end

    # Show all permissions of your apk file.
    #
    # @return [Array<String>, Nil] return nil unless retrieved.
    def permissions(_opts = {})
      result = run_command(apkanalyzer_command, __method__)
      result ? result.to_a : nil
    end

    # Show the min sdk version of your apk file.
    #
    # @return [String, Nil] return nil unless retrieved.
    def min_sdk(_opts = {})
      run_command(apkanalyzer_command, __method__)
    end

    # Show the target sdk version of your apk file.
    #
    # @return [String, Nil] return nil unless retrieved.
    def target_sdk(_opts = {})
      run_command(apkanalyzer_command, __method__)
    end

    # Show the methods reference count of your apk file.
    #
    # @return [Fixnum] return positive value if exists, otherwise -1.
    def method_reference_count(_opts = {})
      result = run_command(apkanalyzer_command, __method__)
      result || -1
    end

    # Show the number of dex of your apk file.
    #
    # @return [Fixnum] return positive value if exists, otherwise -1.
    def dex_count(_opts = {})
      result = run_command(apkanalyzer_command, __method__)
      result || -1
    end

    private

    # @param [Apkstats::Command::Executable] command a wrapper class of a command
    # @param [String] name an attribute name
    def run_command(command, name)
      raise "#{command.command_path} is not found or is not executable" unless command.executable?

      return command.send(name, apk_filepath)
    rescue StandardError => e
      warn("apkstats failed to execute the command #{name} due to #{e.message}")

      on_error(e)
    end

    def apkanalyzer_command
      return @apkanalyzer_command if defined?(@apkanalyzer_command)

      command_path = apkanalyzer_path || `which apkanalyzer`.chomp

      if command_path.empty?
        sdk_path = ENV["ANDROID_HOME"] || ENV["ANDROID_SDK_ROOT"]

        if sdk_path
          tmp_path = File.join(sdk_path, "cmdline-tools/tools/bin/apkanalyzer")
          tmp_path = File.join(sdk_path, "tools/bin/apkanalyzer") unless File.executable?(tmp_path)

          command_path = tmp_path if File.executable?(tmp_path)
        else
          warn("apkstats will not infer the apkanalyzer path in further versions so please include apkanalyer in your PATH or specify it explicitly.")
        end
      end

      command_path = command_path.to_s.chomp

      raise Error, "Please include apkanalyer in your PATH or specify it explicitly." if command_path.empty?
      raise Error, "#{command_path} is not executable." unless File.executable?(command_path)

      @apkanalyzer_command = Apkstats::Command::ApkAnalyzer.new(command_path: command_path)
    end

    # @param [StandardError] err a happened error
    # @return [NilClass]
    def on_error(err)
      warn err.message
      err.backtrace&.each { |line| warn line }
      nil
    end

    def ensure_apk_filepath!
      raise "apk apk_filepath must be specified" if apk_filepath.nil? || !File.file?(apk_filepath)
    end

    def process
      yield
    rescue StandardError => e
      warn("apkstats failed to execute the command due to #{e.message}")

      on_error(e)
      false
    end
  end
end
