# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina-s3'

Gem::Specification.new do |gem|
  gem.name          = 'mina-s3'
  gem.version       = Mina::S3::VERSION
  gem.authors       = ['Stas SUȘCOV']
  gem.email         = ['stas@nerd.ro']
  gem.description   = %q{Adds AWS S3 support for mina.}
  gem.summary       = %q{Deploy to S3 using mina.}
  gem.homepage      = 'https://github.com/stas/mina-s3'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'mina'
  gem.add_dependency 'aws-sdk'
  gem.add_dependency 'mime-types'

  gem.add_development_dependency 'rspec'
end
