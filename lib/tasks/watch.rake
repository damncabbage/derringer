
namespace :watch do
  desc "Runs the Coffee-Script compiler in watch mode."
  task :coffee do
    puts `coffee --watch --compile --output public/build/ public/*.coffee`
  end

  desc "Runs the Sass/Compass compiler in watch mode."
  task :compass do
    puts `compass watch`
  end
end
# Default for :watch namespace
desc "Runs the Sass/Compass and Coffee-Script compilers in watch mode."
multitask :watch => %w(watch:coffee watch:compass)

