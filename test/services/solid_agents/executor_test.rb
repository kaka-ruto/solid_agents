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

      test "marks run succeeded on ok result" do
        agent = SolidAgents::Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")
        run = SolidAgents::Run.create!(agent: agent, source_type: "Error", runtime: "tinyclaw", environment: "test", prompt_payload: {"id" => 1})

        adapter = FakeAdapter.new(SolidAgents::Runtime::Adapter::Result.new(ok: true, output: "done", error: "", metadata: {"exit_status" => 0}))

        original = SolidAgents.method(:runtime_adapter)
        SolidAgents.singleton_class.define_method(:runtime_adapter) { |_runtime| adapter }
        Executor.call(run)

        run.reload
        assert_equal "succeeded", run.status
        assert_equal 1, run.artifacts.count
        assert_equal 2, run.events.count
      ensure
        SolidAgents.singleton_class.define_method(:runtime_adapter, original)
      end

      test "marks run failed on non ok result" do
        agent = SolidAgents::Agent.create!(key: "fixer", name: "Fixer", runtime: "tinyclaw", role: "fixer")
        run = SolidAgents::Run.create!(agent: agent, source_type: "Error", runtime: "tinyclaw", environment: "test", prompt_payload: {"id" => 1})

        adapter = FakeAdapter.new(SolidAgents::Runtime::Adapter::Result.new(ok: false, output: "", error: "bad", metadata: {"exit_status" => 1}))

        original = SolidAgents.method(:runtime_adapter)
        SolidAgents.singleton_class.define_method(:runtime_adapter) { |_runtime| adapter }
        Executor.call(run)

        run.reload
        assert_equal "failed", run.status
        assert_equal "bad", run.error_payload["stderr"]
      ensure
        SolidAgents.singleton_class.define_method(:runtime_adapter, original)
      end
    end
  end
end
