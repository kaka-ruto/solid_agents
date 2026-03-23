# frozen_string_literal: true

require "vcr"
require "webmock/minitest"

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path("cassettes", __dir__)
  config.hook_into :webmock

  config.filter_sensitive_data("<OPENROUTER_API_KEY>") { ENV["OPENROUTER_API_KEY"] }
  config.filter_sensitive_data("<OPENROUTER_AUTH>") do
    key = ENV["OPENROUTER_API_KEY"]
    key ? "Bearer #{key}" : nil
  end

  config.default_cassette_options = {
    record: :once,
    match_requests_on: %i[method uri body]
  }

  config.allow_http_connections_when_no_cassette = false
end

WebMock.disable_net_connect!(allow_localhost: true)
