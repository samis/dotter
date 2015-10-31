# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotter/version'

Gem::Specification.new do |gem|
  gem.name          = "dotter_dotfiles"
  gem.version       = Dotter::VERSION
  gem.summary       = %q{A dotfiles managaer}
  gem.description   = %q{A simple, yet powerful dotfiles manager that wraps around stow and git}
  gem.license       = "MIT"
  gem.authors       = ["Samuel Hodgkins"]
  gem.email         = "samuel.hodgkins@sky.com"
  gem.homepage      = "https://rubygems.org/gems/dotter_dotfiles"

  gem.files         = `git ls-files`.split($/)

  `git submodule --quiet foreach --recursive pwd`.split($/).each do |submodule|
    submodule.sub!("#{Dir.pwd}/",'')

    Dir.chdir(submodule) do
      `git ls-files`.split($/).map do |subpath|
        gem.files << File.join(submodule,subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_runtime_dependency 'thor'
  gem.add_runtime_dependency 'git'
  gem.add_runtime_dependency 'inifile'
end
