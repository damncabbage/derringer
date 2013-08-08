require 'erb'

namespace :btsync do

  desc "Generate the btsync config file from the template; needs SECRET."
  task :config => :environment do
    secret = ENV['SECRET'] or raise "Required: SECRET=shared-secret-key"
    config_source = Rails.root.join('config', 'btsync-template.json.erb')
    config_target = Rails.root.join('config', 'btsync.json')

    erb = ERB.new(File.read(config_source))
    File.open config_target, 'w' do |f|
      f.write erb.result(binding)
    end
  end

  desc "Generate a secret for use with btsync:config"
  task :secret => :environment do
    puts `#{Rails.root.join('bin', 'btsync-linux-i386')} --generate-secret`
  end
end
