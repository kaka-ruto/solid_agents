# frozen_string_literal: true

require "test_helper"

module SolidAgents
  module Runtime
    class OpenclawAdapterTest < ActiveSupport::TestCase
      test "builds openclaw command" do
        agent = SolidAgents::Agent.create!(key: "fixer", name: "Fixer", runtime: "openclaw", role: "fixer")
        run = SolidAgents::Run.create!(agent: agent, source_type: "Error", runtime: "openclaw", environment: "test")

        previous = SolidAgents.openclaw_command
        SolidAgents.openclaw_command = "echo"
        result = OpenclawAdapter.new.execute(run: run, prompt: "fix")
        assert result.ok
        assert_includes result.output, "agent"
      ensure
        SolidAgents.openclaw_command = previous
      end
    end
  end
end
