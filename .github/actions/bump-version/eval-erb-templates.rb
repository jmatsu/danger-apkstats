require 'erb'

base_dir = ARGV.shift
new_version = ARGV.shift
dry_run = ENV['DRY_RUN'] != 'false'

ENV['NEW_VERSION'] = new_version

template_dir = File.expand_path('./templates', __dir__)

Dir.chdir(base_dir) do
  Dir.glob(File.join(template_dir, '**', '*.erb')).each do |tmpl|
    next unless File.file?(tmpl)

    replacee_path = tmpl.gsub("#{template_dir}/", '').gsub(/\.erb\z/, '')

    erb = ERB.new(File.read(tmpl))
    new_content = erb.result(binding)

    if dry_run
      puts "#{replacee_path} will be replaced by the following:"
      puts new_content
    else
      File.write(replacee_path, erb.result(binding))
    end
  end
end

# to fail CI
exit 1 if dry_run
