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
  s.required_ruby_version = ">= 3.2.0" # sync with .github/workflows/actions.yml and .rubocop.yml
  s.add_dependency "rack"
  s.add_dependency "railties", ">= 6.1.0", "< 8.1.0"
  s.add_dependency "sentry-rails", "~> 5.4"
end
