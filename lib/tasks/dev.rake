# Inspired by https://github.com/reInteractive/default_readme/blob/master/dev.rake
# (Demo'd by Mikel at Rorosyd Aug 2012.)

namespace :dev do

  desc "Set up the config files from the examples"
  task :config_files do
    examples = Dir[File.join(File.dirname(__FILE__), '../../config/*.example.yml')]
    examples.each do |example|
      target = example.sub(/\.example\.yml\Z/, '.yml')
      if File.exist? target
        puts "File already exists: #{target}"
      else
        puts `cp -v "#{example}" "#{target}"`
      end
    end
  end

end
