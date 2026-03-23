# frozen_string_literal: true

require "test_helper"

module SolidAgents
  module Runs
    class ExecutorTest < ActiveSupport::TestCase
      class FakeAdapter
        def initialize(result)
          @result = result
        end

        def execute(run:, prompt:)
          raise "missing run" unless run
          raise "missing prompt" if prompt.to_s.empty?

          @result
        end
      end

      test "moves to next stage and enqueues follow-up when successful" do
        run = SolidAgents::Run.find(fixture_id(:received_run))

        adapter = FakeAdapter.new(SolidAgents::Runtime::Adapter::Result.new(ok: true, output: "done", error: "", metadata: {"exit_status" => 0}))
        original = SolidAgents.method(:runtime_adapter)
        SolidAgents.singleton_class.define_method(:runtime_adapter) { |_runtime| adapter }

        assert_enqueued_with(job: SolidAgents::ExecuteRunJob) do
          Executor.call(run)
        end

        run.reload
        assert_equal "triaged", run.stage
        assert_equal "alex", run.stage_owner
        assert_equal "running", run.status
        assert_operator run.handoffs.count, :>=, 1
      ensure
        SolidAgents.singleton_class.define_method(:runtime_adapter, original.to_proc)
      end

      test "marks run failed on non ok result" do
        run = SolidAgents::Run.find(fixture_id(:received_run))

        adapter = FakeAdapter.new(SolidAgents::Runtime::Adapter::Result.new(ok: false, output: "", error: "bad", metadata: {"exit_status" => 1}))
        original = SolidAgents.method(:runtime_adapter)
        SolidAgents.singleton_class.define_method(:runtime_adapter) { |_runtime| adapter }
        Executor.call(run)

        run.reload
        assert_equal "failed", run.status
        assert_equal "bad", run.error_payload["stderr"]
      ensure
        SolidAgents.singleton_class.define_method(:runtime_adapter, original.to_proc)
      end
    end
  end
end
