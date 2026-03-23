# frozen_string_literal: true

require "test_helper"

module SolidAgents
  class RubyLlmLiveFlowTest < ActiveSupport::TestCase
    test "ruby_llm adapter can make a live call and record cassette" do
      cassette_path = File.expand_path("../../cassettes/ruby_llm/live_minimax_m2_7.yml", __dir__)

      unless File.exist?(cassette_path) || ENV["LIVE_LLM"] == "1"
        skip "Set LIVE_LLM=1 to record the cassette once for live API testing"
      end

      key = ENV["OPENROUTER_API_KEY"]
      skip "Set OPENROUTER_API_KEY to run live test" if key.blank?

      run = SolidAgents::Run.find(fixture_id(:received_run))

      VCR.use_cassette("ruby_llm/live_minimax_m2_7", record: :once) do
        result = SolidAgents::Runtime::RubyLlmAdapter.new.execute(run: run, prompt: "Reply with exactly: OK")
        assert result.ok
        assert_match(/OK/i, result.output.to_s)
      end
    end
  end
end
