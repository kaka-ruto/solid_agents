# frozen_string_literal: true

require "test_helper"

module SolidAgents
  module Runtime
    class PiAdapterTest < ActiveSupport::TestCase
      test "builds pi command and returns result" do
        run = SolidAgents::Run.find(fixture_id(:received_run))

        adapter = PiAdapter.new
        adapter.define_singleton_method(:run_command) do |_cmd, *_rest|
          SolidAgents::Runtime::Adapter::Result.new(ok: true, output: "ok", error: "", metadata: {})
        end

        result = adapter.execute(run: run, prompt: "hello")
        assert result.ok
        assert_equal "received", result.metadata[:stage]
        assert_equal "alex", result.metadata[:owner]
      end
    end
  end
end
