# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerApkstats do
    before do
      ENV.delete("ANDROID_HOME")
      ENV.delete("ANDROID_SDK_ROOT")
    end

    it "should be a plugin" do
      expect(Danger::DangerApkstats.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      let(:dangerfile) { testing_dangerfile }
      let(:apkstats) { dangerfile.apkstats }

      before do
        json = File.read(fixture_path + "github_pr.json")
        allow(apkstats.github).to receive(:pr_json).and_return(json)
      end

      # compatibility
      describe "#command_path=" do
        context "unless command_path is given" do
          it { expect { apkstats.send(:apkanalyzer_command) }.to raise_error(Danger::DangerApkstats::Error) }

          context "with ANDROID_HOME" do
            before do
              ENV["ANDROID_HOME"] = "dummy"
            end

            it { expect(apkstats.send(:apkanalyzer_command)).to be_kind_of(Apkstats::Command::ApkAnalyzer) }
          end
        end

        context "if command_path is given" do
          before do
            apkstats.command_path = "dummy"
          end

          it { expect(apkstats.send(:apkanalyzer_command)).to be_kind_of(Apkstats::Command::ApkAnalyzer) }
        end
      end

      describe "#apkanalyzer_path=" do
        context "unless analyzer_path is given" do
          it { expect { apkstats.send(:apkanalyzer_command) }.to raise_error(Danger::DangerApkstats::Error) }

          context "with ANDROID_HOME" do
            before do
              ENV["ANDROID_HOME"] = "dummy"
            end

            it { expect(apkstats.send(:apkanalyzer_command)).to be_kind_of(Apkstats::Command::ApkAnalyzer) }
          end
        end

        context "if analyzer_path is given" do
          before do
            apkstats.apkanalyzer_path = "dummy"
          end

          it { expect(apkstats.send(:apkanalyzer_command)).to be_kind_of(Apkstats::Command::ApkAnalyzer) }
        end
      end

      describe "#compare_with" do
        let(:apk_base) { fixture_path + "app-base.apk" }
        let(:apk_other1) { fixture_path + "app-other1.apk" }

        before do
          apkstats.apkanalyzer_path = `which apkanalyzer`.chomp
        end

        context "unless apk_filepath is specified" do
          it { expect(apkstats.compare_with(apk_other1, do_report: true)).to be_falsey }
        end

        context "otherwise" do
          before do
            apkstats.apk_filepath = apk_base
          end

          it { expect(apkstats.compare_with(apk_other1, do_report: true)).to be_truthy }
        end
      end
    end
  end
end
