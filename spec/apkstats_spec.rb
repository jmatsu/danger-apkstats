# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerApkstats do
    it "should be a plugin" do
      expect(Danger::DangerApkstats.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.apkstats

        # mock the PR data
        # you can then use this, eg. github.pr_author, later in the spec
        json = File.read(fixture_path + "github_pr.json")
        allow(@my_plugin.github).to receive(:pr_json).and_return(json)
      end
    end
  end
end
