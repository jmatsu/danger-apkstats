module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Jumpei Matsuda/danger-apkstats
  # @tags android, apk_stats
  #
  class DangerApkstats < Plugin
    require_relative 'command/executable_command'
    require_relative 'command/apk_analyzer'

    COMMAND_TYPE_MAP = {
      apk_analyzer: Danger::Apkstats::ApkAnalyzer,
    }.freeze

    private_constant(:COMMAND_TYPE_MAP)

    # A command type to be run
    #
    # @return [Symbol, String] either of array( apk_analyzer )
    attr_accessor :command_type

    # An apk file to be operated
    #
    # @return [String]
    attr_accessor :apk_filepath

    # TODO multiple apks

    def compare_with(other_apk_filepath, opts={})
      raise 'apks must be specified' if apk_filepath.nil? || apk_filepath.empty?

      out, err = command.compare_with(apk_filepath, other_apk_filepath)

      if opts[:do_report]
        if out
          left, right, diff, = out.split("\s")
          message("Apk file size was changed by #{diff} : from #{right} to #{left}")
        else
          warn(err)
        end
      end

      return out, err
    end

    def filesize(opts={})
      raise 'apks must be specified' if apk_filepath.nil? || apk_filepath.empty?

      out, = command.filesize(apk_filepath)
      out
    end

    def downloadsize(opts={})
      raise 'apks must be specified' if apk_filepath.nil? || apk_filepath.empty?

      out, = command.downloadsize(apk_filepath)
      out
    end

    private

    def command
      @command ||= COMMAND_TYPE_MAP[command_type.to_sym].new
    end
  end
end
