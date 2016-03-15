Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gift_card'
  s.version     = '3.0.0.beta'
  s.summary     = 'Spree Gift Card'
  s.description = 'Spree Gift Card Extension'

  s.authors     = ['Jeff Dutil']
  s.email       = ['jdutil@burlingtonwebapps.com']
  s.homepage    = 'https://github.com/vinsol/spree_gift_card'

  spree_version = '~> 3.0.4'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.2.0'
  s.requirements << 'none'

  s.add_dependency 'durable_decorator', '~> 0.2.0'
  s.add_dependency 'spree_api',         spree_version
  s.add_dependency 'spree_backend',     spree_version
  s.add_dependency 'spree_core',        spree_version
  s.add_dependency 'spree_frontend',    spree_version

  s.add_development_dependency 'capybara', '~> 2.0'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner', '~> 1.0.1'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails', '~> 5.0.4'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
