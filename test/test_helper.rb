# frozen_string_literal: true
require "bundler/setup"

require "single_cov"
SingleCov.setup :minitest

require "maxitest/global_must"
require "maxitest/autorun"

require "sentry-rails"
require "sentry/user_informer/version"
require "sentry/user_informer"
