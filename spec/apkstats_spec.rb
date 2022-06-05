# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerApkstats do
    it "should be a plugin" do
      expect(Danger::DangerApkstats.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      let(:dangerfile) { testing_dangerfile }
      let(:apkstats) { dangerfile.apkstats }

      before do
        json = File.read(fixture_path.join("github_pr.json"))
        allow(apkstats.github).to receive(:pr_json).and_return(json)
      end

      describe "#compare_with" do
        let(:apk_base) { fixture_path.join("app-base.apk").to_s }
        let(:apk_other1) { fixture_path.join("app-other1.apk").to_s }

        before do
          apkstats.apkanalyzer_path = apkanalyzer_path
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

        context "pathname was given" do
          before do
            apkstats.apk_filepath = Pathname.new(apk_base)
            apkstats.apkanalyzer_path = Pathname.new(apkanalyzer_path)
          end

          it { expect(apkstats.compare_with(Pathname.new(apk_other1), do_report: true)).to be_truthy }
        end
      end
    end
  end
end
