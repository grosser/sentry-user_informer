# frozen_string_literal: true

module Sentry
  module UserInformer
    SENTRY_EVENT_ID = "sentry_event_id"
    class << self
      attr_accessor :placeholder, :template
    end
    self.placeholder = "<!-- SENTRY-USER-INFORMER -->"
    self.template =
      "<br/><br/>Error number: <a href='https://sentry.io/organizations/foo/issues/?query=%{event_id}'>%{event_id}</a>" # rubocop:disable Style/FormatStringToken

    # render captured exception so users can click it
    # testing: set `config.consider_all_requests_local = false` and add `raise 'testing'` to an action
    class ExceptionRenderer
      def initialize(app)
        @app = app
      end

      def call(env)
        Thread.current[Sentry::UserInformer::SENTRY_EVENT_ID] = nil # reset to not keep old exception around
        status, headers, body = @app.call(env)
        if (event_id = Thread.current[Sentry::UserInformer::SENTRY_EVENT_ID])
          replacement = format(Sentry::UserInformer.template, event_id: event_id)
          body = body.map { |chunk| chunk.gsub(Sentry::UserInformer.placeholder, replacement) }
          headers["Content-Length"] = body.sum(&:bytesize).to_s # not sure if this is needed, but it does not hurt
        end
        [status, headers, body]
      end
    end
  end
end

if defined?(::Rails::Railtie)
  raise "Load sentry-rails before sentry-user_informer" unless defined?(Sentry::Rails)

  # override capture_exception to store the exception in globally since it does not have access to any other state
  Sentry::Rails::CaptureExceptions.prepend(
    Module.new do
      def capture_exception(_exception)
        event = super
        Thread.current[Sentry::UserInformer::SENTRY_EVENT_ID] = event&.event_id
        event
      end
    end
  )

  module Sentry
    module UserInformer
      class Railtie < ::Rails::Railtie
        initializer("sentry.user_informer") do |app|
          app.config.middleware.insert_before ActionDispatch::ShowExceptions, Sentry::UserInformer::ExceptionRenderer
        end
      end
    end
  end
end
