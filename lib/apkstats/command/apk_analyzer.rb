module Danger::Apkstats
  class ApkAnalyzer
    include Danger::Apkstats::ExecutableCommand

    def compare_with(apk_filepath, other_apk_filepath)
      out, err = run_command('apk', 'compare', '--different-only', apk_filepath, other_apk_filepath)

      if out
        left, right, diff, = out.partition("\n").first.split("\s")
        return "Apk file size was changed by #{diff} : from #{right} to #{left}", nil
      else
        return nil, err
      end
    end

    def filesize(apk_filepath)
      run_command('apk', 'file-size', apk_filepath)
    end

    def downloadsize(apk_filepath)
      run_command('apk', 'download-size', apk_filepath)
    end

    private

    def run_command(*args)
      puts "#{command} #{args.join(' ')}"
      out, err, status = Open3.capture3("#{command} #{args.join(' ')}")
      return out, nil if status == 0
      return nil, (err || 'failed due while executing a command')
    end

    def command
      @command ||= "#{ENV.fetch('ANDROID_SDK_HOME')}/tools/bin/apkanalyzer"
    end
  end
end