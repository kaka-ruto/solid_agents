# frozen_string_literal: true

require "test_helper"

module SolidAgents
  module Runs
    class DispatchTest < ActiveSupport::TestCase
      Source = Struct.new(:id, :attributes)

      test "creates run, board item, and enqueues execution" do
        source = Source.new(42, {"id" => 42, "message" => "boom"})

        assert_enqueued_with(job: SolidAgents::ExecuteRunJob) do
          run = Dispatch.call(source: source, agent_key: "alex")
          assert_equal "received", run.stage
          assert_equal "alex", run.stage_owner
          assert_equal "queued", run.status
          assert_equal "pi", run.runtime
          assert_equal "received", run.work_item.column_key
          assert_equal 1, run.events.count
        end
      end
    end
  end
end
