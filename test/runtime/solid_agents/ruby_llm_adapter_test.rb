# frozen_string_literal: true

require "test_helper"

module SolidAgents
  module Runtime
    class RubyLlmAdapterTest < ActiveSupport::TestCase
      class FakeAgent
        def initialize(run:, context:)
          @run = run
          @context = context
        end

        def call(_prompt)
          Struct.new(:content).new("ok")
        end
      end

      test "executes through RubyLLM agent class and returns metadata" do
        run = SolidAgents::Run.find(fixture_id(:received_run))

        original = SolidAgents::Agents.method(:for_owner)
        SolidAgents::Agents.define_singleton_method(:for_owner) { |_owner| FakeAgent }

        result = RubyLlmAdapter.new.execute(run: run, prompt: "hello")
        assert result.ok
        assert_equal "ok", result.output
        assert_equal "received", result.metadata[:stage]
        assert_equal "alex", result.metadata[:owner]
      ensure
        SolidAgents::Agents.define_singleton_method(:for_owner, original.to_proc)
      end
    end
  end
end
