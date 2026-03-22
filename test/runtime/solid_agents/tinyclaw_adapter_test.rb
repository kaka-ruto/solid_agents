# frozen_string_literal: true

require "test_helper"

module SolidAgents
  module Runtime
    class TinyclawAdapterTest < ActiveSupport::TestCase
      test "builds tinyclaw command" do
        agent = SolidAgents::Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")
        run = SolidAgents::Run.create!(agent: agent, source_type: "Error", runtime: "tinyclaw", environment: "test")

        previous = SolidAgents.tinyclaw_command
        SolidAgents.tinyclaw_command = "echo"
        result = TinyclawAdapter.new.execute(run: run, prompt: "fix")
        assert result.ok
        assert_includes result.output, "@fixer"
      ensure
        SolidAgents.tinyclaw_command = previous
      end
    end
  end
end
