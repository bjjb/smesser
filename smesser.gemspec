# -*- encoding: utf-8 -*-
require File.expand_path('../lib/smesser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["JJ Buckley"]
  gem.email         = ["jj@bjjb.org"]
  gem.description   = %q{Send free text messages!}
  gem.summary       = %q{SMeSser helps you send SMSs using various mobile provider's websites. The gem comes with a binary, which helps you set up the details for your own provider, and with a library which you can integrate into nicer front-ends.}
  gem.homepage      = "http://jjbuckley.github.com/smesser"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "smesser"
  gem.require_paths = ["lib"]
  gem.version       = Smesser::VERSION
  gem.add_development_dependency 'rake'
  gem.add_dependency 'mechanize', '~> 2.3'
end
