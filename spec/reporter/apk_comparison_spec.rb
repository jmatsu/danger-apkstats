# frozen_string_literal: true

require_relative "../spec_helper"

describe Apkstats::Reporter::ApkComparison do
  let(:apkanalyzer_command) { Apkstats::Command::ApkAnalyzer.new(command_path: apkanalyzer_path) }
  let(:base_apk_info) { Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: apk_filepath) }
  let(:other_apk_info) { Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: other_apk_filepath) }

  let(:apk_filepath) { fixture_path.join("app-base.apk") }
  let(:other_apk_filepath) { fixture_path.join("app-other1.apk") }

  describe "#generate_markdown" do
    subject do
      Apkstats::Reporter::ApkComparison.new(
        base_apk_info: base_apk_info,
        other_apk_info: other_apk_info
      ).generate_markdown
    end

    it { is_expected.to eq(File.read(fixture_path.join("apk_comparison_of_base_and_other1.md"))) }
  end
end
