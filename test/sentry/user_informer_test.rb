# frozen_string_literal: true
require_relative "../test_helper"

SingleCov.covered! uncovered: 6

describe Sentry::UserInformer do
  it "has a VERSION" do
    Sentry::UserInformer::VERSION.must_match /^[.\da-z]+$/
  end

  describe Sentry::UserInformer::ExceptionRenderer do
    let(:event_ids) { ["123"] }
    let(:inner) do
      lambda do |_env|
        Thread.current[Sentry::UserInformer::SENTRY_EVENT_ID] = event_ids.shift
        [200, {}, ["Hi<!-- SENTRY-USER-INFORMER -->there"]]
      end
    end
    let(:app) { Sentry::UserInformer::ExceptionRenderer.new(inner) }

    it "renders" do
      app.call({}).must_equal [
        200,
        { "Content-Length" => "102" },
        ["Hi<br/><br/>Error number: <a href='https://sentry.io/organizations/foo/issues/?query=123'>123</a>there"]
      ]
    end

    it "does not render when exception was not caught" do
      event_ids.pop
      app.call({}).must_equal [
        200,
        {},
        ["Hi<!-- SENTRY-USER-INFORMER -->there"]
      ]
    end
  end
end
