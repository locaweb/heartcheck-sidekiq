lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heartcheck/sidekiq/version'

Gem::Specification.new do |spec|
  spec.name = 'heartcheck-sidekiq'
  spec.version = Heartcheck::Sidekiq::VERSION
  spec.authors = ['Locaweb']
  spec.email = ['desenvolvedores@locaweb.com.br']
  spec.summary = 'A sidekiq checker'
  spec.description = 'Plugin to check sidekiq connection in heartcheck.'
  spec.homepage = 'http://developer.locaweb.com.br'
  spec.license = 'MIT'

  spec.files = Dir['lib/**/*'].select { |f| File.file?(f) }
  spec.executables = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(/^spec\//)
  spec.require_paths = ['lib']

  spec.add_dependency 'heartcheck', '~> 2.0'
  spec.add_dependency 'sidekiq', '>= 2.0.0', '< 6.0.0'

  spec.add_development_dependency 'pry-nav', '~> 0.2.0', '>= 0.2.4'
  spec.add_development_dependency 'rspec', '~> 3.1.0', '>= 3.1.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
  # for documentation
  spec.add_development_dependency 'yard', '~> 0.9.11'
  spec.add_development_dependency 'redcarpet', '~> 3.2.0', '>= 3.2.2'
end
