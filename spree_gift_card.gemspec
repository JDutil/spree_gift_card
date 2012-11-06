Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gift_card'
  s.version     = '1.0.0.beta'
  s.summary     = 'Spree Gift Card'
  s.description = 'Spree Gift Card Extension'

  s.author      = ['Jeff Dutil']
  s.email       = ['jdutil@burlingtonwebapps.com']
  s.homepage    = 'http://github.com/jdutil/spree_gift_card'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.required_ruby_version = '>= 1.9.2'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.2.0'

  s.add_development_dependency 'capybara', '~> 1.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 3.6'# '~> 4.1' # cant use 4.1 until Spree's factories are compatible maybe in 1.2.x
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.11'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
