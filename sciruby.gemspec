# coding: utf-8
$: << File.join(File.dirname(__FILE__), 'lib')
require 'sciruby'
require 'date'

SCIRUBY_FULL = false unless defined?(SCIRUBY_FULL)

Gem::Specification.new do |s|
  s.name        = SCIRUBY_FULL ? 'sciruby-full' : 'sciruby'
  s.date        = Date.today.to_s
  s.version     = SciRuby::VERSION
  s.authors     = ['SciRuby Development Team']
  s.email       = ['sciruby-dev@googlegroups.com']
  s.license     = 'BSD'
  s.homepage    = 'http://sciruby.com'
  s.summary     =
  s.description = "Scientific gems for Ruby#{SCIRUBY_FULL ? ' (Full installation)' : ''}"

  s.require_paths = %w(lib)
  s.files = `git ls-files`.split($/)

  gems = SciRuby.gems.each_value.sort_by {|gem| gem[:name] }.reject do |gem|
    gem[:maintainer] == 'stdlib' || %w(sciruby sciruby-full).include?(gem[:name])
  end

  if SCIRUBY_FULL
    s.files.delete 'sciruby.gemspec'
    s.files.reject! {|f| f =~ /\Alib/ }

    s.add_runtime_dependency 'sciruby', "= #{SciRuby::VERSION}"
    gems.reject {|gem| gem[:exclude] }.each {|gem| s.add_runtime_dependency gem[:name], *gem[:version] }
  else
    s.files.delete 'sciruby-full.gemspec'

    m = "Please consider installing 'sciruby-full' or the following gems:\n"
    gems.each {|gem| m << "  * #{gem[:name]} - #{gem[:description]}\n" }
    s.post_install_message = m << "\n"
  end

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'slim'
end
