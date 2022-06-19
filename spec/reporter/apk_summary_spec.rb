# frozen_string_literal: true

require_relative "../spec_helper"

describe Apkstats::Reporter::ApkSummary do
  let(:apkanalyzer_command) { Apkstats::Command::ApkAnalyzer.new(command_path: apkanalyzer_path) }
  let(:apk_info) { Apkstats::Entity::ApkInfo.new(command: apkanalyzer_command, apk_filepath: apk_filepath) }

  let(:apk_base_filepath) { fixture_path.join("app-base.apk") }
  let(:apk_other1_filepath) { fixture_path.join("app-other1.apk") }

  describe "#generate_markdown" do
    subject do
      Apkstats::Reporter::ApkSummary.new(
        apk_info: apk_info
      ).generate_markdown
    end

    let(:apk_filepath) { apk_base_filepath }

    it { is_expected.to eq(File.read(fixture_path.join("apk_summary_of_base.md"))) }

    context "if the target is other1.apk, " do
      let(:apk_filepath) { apk_other1_filepath }

      it { is_expected.to eq(File.read(fixture_path.join("apk_summary_of_other1.md"))) }
    end
  end
end
