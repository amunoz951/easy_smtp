# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'easy_smtp'
  spec.version       = '0.1.0'
  spec.authors       = ['Alex Munoz']
  spec.email         = ['amunoz951@gmail.com']
  spec.license       = 'Apache-2.0'
  spec.summary       = 'Ruby library for sending emails easily.'
  spec.homepage      = 'https://github.com/amunoz951/easy_smtp'

  spec.required_ruby_version = '>= 2.3'

  spec.files         = Dir['LICENSE', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'easy_json_config', '~> 0'
end
