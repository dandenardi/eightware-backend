
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 3.2.0"

gem "dotenv-rails", groups: [:development, :test]
gem "rails", "~> 7.2.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "bootsnap", ">= 1.4.4", require: false
gem "image_processing", "~> 1.2"


gem "bcrypt", "~> 3.1.7"
gem "devise"
gem "devise-jwt"


gem "rack-cors"


gem "jsonapi-serializer"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
end