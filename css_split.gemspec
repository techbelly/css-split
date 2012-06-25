require File.join([File.dirname(__FILE__),'lib','css_split','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'css_split'
  s.version = CssSplit::VERSION
  s.author = 'Ben Griffiths'
  s.email = 'bengriffiths@gmail.com'
  s.homepage = 'http://techbelly.com'
  s.platform = Gem::Platform::RUBY
#TODO: Project needs a summary
  s.summary = ''
  s.files = %w(
bin/css_split
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','css_split.rdoc']
  s.rdoc_options << '--title' << 'css_split' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'css_split'
  s.add_dependency('css_parser')
  s.add_dependency('sass')
  
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
end
