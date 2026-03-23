# frozen_string_literal: true

require "test_helper"

module SolidAgents
  class RunTest < ActiveSupport::TestCase
    test "sets defaults on create" do
      run = Run.create!(agent: SolidAgents::Agent.find(fixture_id(:alex)), source_type: "SolidErrors::Error", source_id: 11, environment: "test")

      assert_equal "queued", run.status
      assert_equal "received", run.stage
      assert_equal "alex", run.stage_owner
      assert_equal "pi", run.runtime
      assert_equal "bin/rails test", run.test_command
    end

    test "appends sequenced events" do
      run = SolidAgents::Run.find(fixture_id(:received_run))

      run.append_event!("one", message: "first")
      run.append_event!("two", message: "second")

      assert_equal [1, 2, 3], run.events.order(:sequence).pluck(:sequence)
    end

    test "transitions stage and board column" do
      run = SolidAgents::Run.find(fixture_id(:received_run))

      run.transition_to!("triaged", actor: "alex", message: "triaged")

      assert_equal "triaged", run.reload.stage
      assert_equal "triaged", run.work_item.reload.column_key
      assert_equal "alex", run.stage_owner
    end
  end
end
