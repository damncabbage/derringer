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

namespace :coffee do
  task :watch do
    puts `coffee --watch --compile --output build/ *.coffee`
  end
end

namespace :compass do
  task :watch do
    puts `compass watch`
  end
end

multitask :watch => %w(coffee:watch compass:watch)
