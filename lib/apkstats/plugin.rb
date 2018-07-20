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
    COMMAND_TYPE_MAP = {
      apk_analyzer: Danger::ApkStats::ApkAnalyzer,
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
      raise 'apks must be specified' if apk_filepath.blank?

      strict_mode = opts[:strict] || false
      should_report = opts[:report] || false

      out, err = command.compare_with(apk_filepath, other_apk_filepath)

      if should_report
        report(out, err, strict_mode)
      else
        echo(out, err)
      end
    end

    def filesize(opts={})
      raise 'apks must be specified' if apk_filepath.blank?

      strict_mode = opts[:strict] || false
      should_report = opts[:report] || false

      message, err = command.filesize(apk_filepath)

      if should_report
        report(out, err, strict_mode)
      else
        echo(out, err)
      end
    end

    def downloadsize(opts={})
      raise 'apks must be specified' if apk_filepath.blank?

      strict_mode = opts[:strict] || false
      should_report = opts[:report] || false

      message, err = command.downloadsize(apk_filepath)

      if should_report
        report(out, err, strict_mode)
      else
        echo(out, err)
      end
    end

    private

    def command
      @command ||= COMMAND_TYPE_MAP[command_type.to_sym]
    end

    def report(out, err, strict_mode)
      if err
        strict_mode ? fail(err) : warn(err)
      else
        message(out)
      end
    end

    def echo(out, err)
      if err
        STDERR.puts(err)
      else
        puts(out)
      end
    end
  end
end
