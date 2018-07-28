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
      ::Apkstats::Entity::Features.new(parse_features(run_command("apk", "features", apk_filepath)))
    end

    def non_required_features(apk_filepath)
      all = Apkstats::Entity::Features.new(parse_features(run_command("apk", "features", "--not-required", apk_filepath)))
      all - required_features(apk_filepath)
    end

    def permissions(apk_filepath)
      ::Apkstats::Entity::Permissions.new(parse_permissions(run_command("manifest", "permissions", apk_filepath)))
    end

    def min_sdk(apk_filepath)
      run_command("manifest", "min-sdk", apk_filepath)
    end

    def target_sdk(apk_filepath)
      run_command("manifest", "target-sdk", apk_filepath)
    end

    private

    def parse_permissions(command_output)
      command_output.split(/\r?\n/).map { |s| to_permission(s) }
    end

    def to_permission(str)
      # If maxSdkVersion is specified, the output is like `android.permission.INTERNET' maxSdkVersion='23`
      name_seed, max_sdk_seed = str.strip.split(/\s/)
      ::Apkstats::Entity::Permission.new(name_seed.gsub(/'$/, ""), max_sdk_seed && max_sdk_seed[/[0-9]+/])
    end

    def parse_features(command_output)
      command_output.split(/\r?\n/).map { |s| to_feature(s) }
    end

    def to_feature(str)
      # format / name impiled: xxxx
      # not-required and impiled cannot co-exist so it's okay to parse them like this
      name, kind, tail = str.strip.split(/\s/, 3)

      ::Apkstats::Entity::Feature.new(name, not_required: kind == "not-required", impiled_reason: kind == "impiled:" && tail)
    end

    def run_command(*args)
      out, err, status = Open3.capture3("#{command_path} #{args.join(' ')}")
      raise err unless status.success?
      out.rstrip
    end
  end
end
