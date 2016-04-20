source 'https://rubygems.org'

gem 'rails', '~> 3.2.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Redis part
gem 'hiredis', '~> 0.4.5'
gem 'redis', '~> 2.2.2', require: %w(redis/connection/hiredis redis)
gem 'ohm', '~> 0.1.5'
gem 'ohm-contrib', '~> 0.1.2'

# SQLite part
gem 'sqlite3', '~> 1.3.6'

gem 'json', '~> 1.6.7'
gem 'haml', '~> 3.1.6'


gem 'rest-client', '~> 1.6.7'

gem 'youtube_it', '~> 2.1.5'
gem 'vimeo', '~> 1.5.2'


gem 'jquery-rails', '~> 2.0.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.5'
  #gem 'yui-compressor', '~> 0.9.6'
end

#make them available on production
gem 'coffee-rails', '~> 3.2.2'
gem 'uglifier', '~> 1.2.4'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', '~> 2.12.0'

# Monitor with NewRelic
gem 'newrelic_rpm', '~> 3.3.5'

# cron gem
gem 'whenever', '~> 0.7.3'
# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
#   gem 'webrat'
  gem 'ruby_core_source', '~> 0.1.5'
end


group :production do
  #gem 'therubyracer', '~> 0.10.1'
  gem 'unicorn', '~> 4.3.1'

  gem 'exception_notification', '~> 2.6.1', require: 'exception_notifier'
end
