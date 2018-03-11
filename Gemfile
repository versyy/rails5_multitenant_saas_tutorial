source 'https://rubygems.org'

ruby '2.5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bundler', '~> 1.16.1'

# basic rails configuration
gem 'pg', '>= 1.0.0'
gem 'puma', '~> 3.11.2'
gem 'rails', '~> 5.1.5'
gem 'sass-rails', '~> 5.0.7'
gem 'turbolinks', '~> 5.1.0'
gem 'uglifier', '~> 4.1.6'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7.0'

# multitenant SaaS components
gem 'acts_as_tenant', '~> 0.4.2'
gem 'devise', '~> 4.4.1'

# misc components
gem 'validate_url', '~> 1.0.2'

group :development, :test do
  gem 'byebug', '~> 10.0.0'
  gem 'codeclimate-test-reporter', '~> 1.0.7'
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'faker', '~> 1.8.7'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'guard-rubocop', '~> 1.3.0'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'simplecov', '~> 0.15.1'
end

group :development do
  gem 'listen', '~> 3.1.5'
  gem 'spring', '~> 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~> 3.5.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
