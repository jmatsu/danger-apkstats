module Danger::Apkstats
  module ExecutableCommand
    require "open3"
    
    # @return [String, String] ([ size, old_size, changed_by ].join(' '), err message)
    def compare_with(apk_filepath, other_apk_filepath)
        unsupported!
    end

    def filesize(apk_filepath)
        unsupported!
    end

    def downloadsize(apk_filepath)
        unsupported!
    end

    private

    def unsupported!
        raise "#{__method__} is not supported by #{self.class}"
    end
  end
end