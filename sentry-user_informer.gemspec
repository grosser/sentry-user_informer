# frozen_string_literal: true
name = "sentry-user_informer"
$LOAD_PATH << File.expand_path("lib", __dir__)
require "#{name.tr("-", "/")}/version"

Gem::Specification.new name, Sentry::UserInformer::VERSION do |s|
  s.summary = "show link to errors on exception page"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = ">= 2.7.0"
  s.add_runtime_dependency "rack"
  s.add_runtime_dependency "railties", ">= 7.0.0", "< 7.1.0"
  s.add_runtime_dependency "sentry-rails", "~> 5.3"
end
