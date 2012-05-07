require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

# Front-End Dev
namespace :watch do
  desc "Runs the Coffee-Script compiler in watch mode."
  task :coffee do
    puts `coffee --watch --compile --output build/ *.coffee`
  end

  desc "Runs the Sass/Compass compiler in watch mode."
  task :compass do
    puts `compass watch`
  end
end
# Default for :watch namespace
desc "Runs the Sass/Compass and Coffee-Script compilers in watch mode."
multitask :watch => %w(watch:coffee watch:compass)


multitask :watch => %w(coffee:watch compass:watch)
