# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunto-avatar/version'

Gem::Specification.new do |spec|
  spec.name          = 'bunto-avatar'
  spec.version       = Bunto::Avatar::VERSION
  spec.authors       = ['Ben Balter', 'Suriyaa Kudo']
  spec.email         = ['ben.balter@github.com', 'SuriyaaKudoIsc@users.noreply.github.com']

  spec.summary       = 'A Bunto plugin for rendering GitHub avatars'
  spec.homepage      = 'https://github.com/benbalter/bunto-avatar'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'bunto'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
