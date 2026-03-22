# frozen_string_literal: true

require "test_helper"

module SolidAgents
  class RunTest < ActiveSupport::TestCase
    test "sets defaults on create" do
      agent = Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")

      run = Run.create!(agent: agent, source_type: "SolidErrors::Error", source_id: 1, runtime: "tinyclaw", environment: "test")

      assert_equal "queued", run.status
      assert_equal "bin/rails test", run.test_command
    end

    test "appends sequenced events" do
      agent = Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")
      run = Run.create!(agent: agent, source_type: "Error", runtime: "tinyclaw", environment: "test")

      run.append_event!("one", message: "first")
      run.append_event!("two", message: "second")

      assert_equal [1, 2], run.events.order(:sequence).pluck(:sequence)
    end
  end
end
