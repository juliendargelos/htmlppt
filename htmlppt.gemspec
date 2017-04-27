$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "htmlppt/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "htmlppt"
  s.version     = Htmlppt::VERSION
  s.authors     = ['Julien Darglos']
  s.email       = ['contact@juliendargelos.com']
  s.homepage    = 'https://www.github.com/juliendargelos/htmlppt'
  s.summary     = 'Converts HTML to PPT.'
  s.description = 'Parses HTML contents to generate PowerPoint files.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.0.2'
  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_dependency 'powerpoint'

  s.add_development_dependency 'sqlite3'
end
