# Setup simplecov first to make sure coverage happens through everything.
require 'simplecov'
SimpleCov.start do
  add_filter '/config/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Libraries', 'lib'
  add_group 'Specs', 'spec'
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'

require 'database_cleaner'
require 'factory_girl'
FactoryGirl.find_definitions
require 'ffaker'
require 'shoulda-matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories defined in spree_core
require 'spree/testing_support/factories'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/url_helpers'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.extend Spree::TestingSupport::AuthorizationHelpers::Request, :type => :feature # once spree updates this can be removed
  config.color = true

  # Set to false for running JS drivers.
  config.use_transactional_fixtures = false

  config.before :each do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

end
