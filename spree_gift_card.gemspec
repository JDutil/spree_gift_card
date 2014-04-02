Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gift_card'
  s.version     = '1.0.0.beta'
  s.summary     = 'Spree Gift Card'
  s.description = 'Spree Gift Card Extension'

  s.authors     = ['Jeff Dutil']
  s.email       = ['jdutil@burlingtonwebapps.com']
  s.homepage    = 'http://github.com/jdutil/spree_gift_card'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.required_ruby_version = '>= 1.9.3'
  s.requirements << 'none'

  s.add_dependency 'durable_decorator', '~> 0.2.0'
  s.add_dependency 'spree_api',         '~> 2.1.0'
  s.add_dependency 'spree_backend',     '~> 2.1.0'
  s.add_dependency 'spree_core',        '~> 2.1.0'
  s.add_dependency 'spree_frontend',    '~> 2.1.0'

  s.add_development_dependency 'capybara', '~> 2.0'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner', '~> 1.0.1'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sprockets', '<= 2.11.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers', '>= 1.5.4'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-rails'
end
