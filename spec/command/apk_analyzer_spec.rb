# frozen_string_literal: true

require_relative "../spec_helper"

module Apkstats::Command
  describe Apkstats::Command::ApkAnalyzer do
    let(:apk_base) { fixture_path + "app-base.apk" }
    let(:apk_other1) { fixture_path + "app-other1.apk" }
    let(:apk_other2) { fixture_path + "app-other2.apk" }
    let(:apk_other3) { fixture_path + "app-other3.apk" }
    let(:apk_other4) { fixture_path + "app-other4.apk" }
    let(:apk_other5) { fixture_path + "app-other5.apk" }
    let(:apk_method64k) { fixture_path + "app-method64k.apk" }

    it "should use custom path if set" do
      expect(ApkAnalyzer.new({}).command_path).to eq("#{ENV.fetch('ANDROID_HOME')}/tools/bin/apkanalyzer")
      expect(ApkAnalyzer.new(command_path: "/y/z").command_path).to eq("/y/z")
    end

    context "command" do
      let(:command) { ApkAnalyzer.new({}) }

      it "file_size should return apk size" do
        expect(command.file_size(apk_base)).to eq(1_621_248.to_s)
      end

      it "download_size should return apk size for download" do
        expect(command.download_size(apk_base)).to eq(1_308_587.to_s)
      end

      it "required_features should return features expect not-required features" do
        features = command.required_features(apk_other1).values

        expect(features).not_to be_empty
        expect(features.any?(&:not_required?)).to be_falsey
      end

      it "non_required_features should return only not-required features" do
        features = command.non_required_features(apk_other1).values

        expect(features).not_to be_empty
        expect(features.all?(&:not_required?)).to be_truthy
      end

      it "permissions should return features all permissions" do
        permissions = command.permissions(apk_other4).values

        expect(permissions).not_to be_empty
      end

      it "min_sdk should return min sdk" do
        expect(command.min_sdk(apk_base)).to eq("15")
        expect(command.min_sdk(apk_other5)).to eq("27")
      end

      it "target_sdk should return target sdk" do
        expect(command.target_sdk(apk_base)).to eq("28")
      end

      it "method_reference_count should return reference count" do
        expect(command.method_reference_count(apk_base)).to eq(15_720)
        expect(command.method_reference_count(apk_method64k)).to eq(124_304)
      end

      it "dex_count should return dex count" do
        expect(command.dex_count(apk_base)).to eq(1)
        expect(command.dex_count(apk_method64k)).to eq(2)
      end
    end

    context "to_permission" do
      it "should return a permission without max_sdk" do
        expect(
          ApkAnalyzer.to_permission("android.permission.INTERNET")
        ).to eq(::Apkstats::Entity::Permission.new("android.permission.INTERNET", max_sdk: nil))
      end

      it "should return a permission with max_sdk" do
        expect(
          ApkAnalyzer.to_permission("android.permission.INTERNET' maxSdkVersion='23")
        ).to eq(::Apkstats::Entity::Permission.new("android.permission.INTERNET", max_sdk: "23"))
      end
    end

    context "parse_permissions" do
      it "should return each permissions" do
        command_output = [
          "android.permission.INTERNET",
          "android.permission.INTERNET' maxSdkVersion='23"
        ].join("\n")

        expect(ApkAnalyzer.parse_permissions(command_output)).to contain_exactly(
          ::Apkstats::Entity::Permission.new("android.permission.INTERNET", max_sdk: nil),
          ::Apkstats::Entity::Permission.new("android.permission.INTERNET", max_sdk: "23")
        )
      end
    end

    context "parse_features" do
      it "should return each features" do
        command_output = [
          "android.hardware.camera",
          "android.hardware.faketouch not-required",
          "android.hardware.camera implied: requested android.permission.CAMERA permission",
          "android.hardware.faketouch implied: default feature for all apps",
        ].join("\n")

        expect(ApkAnalyzer.parse_features(command_output)).to contain_exactly(
          ::Apkstats::Entity::Feature.new("android.hardware.camera", not_required: false, implied_reason: nil),
          ::Apkstats::Entity::Feature.new("android.hardware.faketouch", not_required: true, implied_reason: nil),
          ::Apkstats::Entity::Feature.new("android.hardware.camera", not_required: false, implied_reason: "requested android.permission.CAMERA permission"),
          ::Apkstats::Entity::Feature.new("android.hardware.faketouch", not_required: false, implied_reason: "default feature for all apps")
        )
      end
    end

    context "to_feature" do
      it "should return a feature" do
        expect(
          ApkAnalyzer.to_feature("android.hardware.camera")
        ).to eq(::Apkstats::Entity::Feature.new("android.hardware.camera", not_required: false, implied_reason: nil))
      end

      it "should return a not-required feature" do
        expect(
          ApkAnalyzer.to_feature("android.hardware.faketouch not-required")
        ).to eq(::Apkstats::Entity::Feature.new("android.hardware.faketouch", not_required: true, implied_reason: nil))
      end

      it "should return an implied feature" do
        expect(
          ApkAnalyzer.to_feature("android.hardware.camera implied: requested android.permission.CAMERA permission")
        ).to eq(::Apkstats::Entity::Feature.new("android.hardware.camera", not_required: false, implied_reason: "requested android.permission.CAMERA permission"))

        expect(
          ApkAnalyzer.to_feature("android.hardware.faketouch implied: default feature for all apps")
        ).to eq(::Apkstats::Entity::Feature.new("android.hardware.faketouch", not_required: false, implied_reason: "default feature for all apps"))
      end
    end
  end
end
