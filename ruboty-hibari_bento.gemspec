lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/hibari_bento/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruboty-hibari_bento'
  spec.version       = Ruboty::HibariBento::VERSION
  spec.authors       = ['Masaki Enjo']
  spec.email         = %w(emsk1987@gmail.com)
  spec.summary       = 'Ruboty handler to get information of Hibari Bento, the bento shop in Ruby City MATSUE.'
  spec.homepage      = 'http://github.com/emsk/ruboty-hibari_bento'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency('ruboty')
  spec.add_runtime_dependency('koala')
  spec.add_runtime_dependency('redis')
  spec.add_runtime_dependency('redis-namespace')
  spec.add_development_dependency('bundler', '~> 1.7')
  spec.add_development_dependency('rake', '~> 10.0')
end
