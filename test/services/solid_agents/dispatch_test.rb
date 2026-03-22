# frozen_string_literal: true

require "test_helper"

module SolidAgents
  module Runs
    class DispatchTest < ActiveSupport::TestCase
      Source = Struct.new(:id, :attributes)

      test "creates run and enqueues execution" do
        agent = SolidAgents::Agent.create!(
          key: "fixer",
          name: "Fixer",
          runtime: "tinyclaw",
          role: "fixer",
          enabled: true,
          environment: "test",
          working_directory: "/tmp/repo"
        )

        source = Source.new(42, {"id" => 42, "message" => "boom"})

        assert_enqueued_with(job: SolidAgents::ExecuteRunJob) do
          run = Dispatch.call(source: source, agent_key: "fixer")
          assert_equal agent, run.agent
          assert_equal "queued", run.status
          assert_equal "tinyclaw", run.runtime
          assert_equal 1, run.events.count
        end
      end
    end
  end
end
