source :rubygems

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'compass'
gem 'haml'
gem 'activerecord', :require => "active_record"
gem 'couchrest_model'
gem 'mysql2'
gem 'therubyracer'

gem 'coffee-script'
#gem 'uglifier', '~> 1.0'
#gem 'compass', '~> 0.12.alpha'
gem 'bootstrap-sass'

# Test requirements
group :test do
  gem 'rack-test', :require => "rack/test"
  gem 'factory_girl'
  gem 'ffaker'
end

group :test, :development do
  gem 'rspec'
  gem 'database_cleaner'
  gem 'debugger'
  gem 'hpricot'
end

# Padrino Stable Gem
gem 'padrino', '0.10.6'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.6'
# end
