# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glitch/version'

Gem::Specification.new do |spec|
  spec.name = 'glitch-game'
  spec.version = Glitch::VERSION
  spec.authors = ['Odin Dutton']
  spec.summary = 'A terminal based Cookie Clicker style game.'
  spec.homepage = 'https://github.com/twe4ked/glitch'
  spec.license = 'MIT'
  spec.files = `git ls-files -z`.split("\x0")
  spec.executables << 'glitch'
  spec.require_paths = ['.']
  spec.add_runtime_dependency 'curses', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
