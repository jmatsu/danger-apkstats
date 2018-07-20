module Danger::ApkStats
    class ApkAnalyzer
        include ExecutableCommand

        def compare_with(apk_filepath, other_apk_filepath)
            run_command('compare', '--different-only', apk_filepath, other_apk_filepath)
        end

        def filesize(apk_filepath)
            run_command('apk', 'file-size', apk_filepath)
        end

        def downloadsize(apk_filepath)
            run_command('apk', 'download-size', apk_filepath)
        end

        private

        def run_command(*args)
            out, err, status = Open3.capture3("#{command} #{args.join(' ')}")
            return out, nil if status == 0
            return nil, (err || 'failed due while executing a command')
        end

        def command
            @command ||= "#{ENV.fetch('ANDROID_SDK_HOME')}/tools/bin/apkanalyzer"
        end
    end
end