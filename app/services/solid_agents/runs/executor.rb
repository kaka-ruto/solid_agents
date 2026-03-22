# frozen_string_literal: true

module SolidAgents
  module Runs
    class Executor
      def self.call(run)
        run.update!(status: :running, started_at: Time.current)
        run.append_event!("runtime_started", message: "Runtime execution started")

        prompt = PromptBuilder.call(run: run, context: run.prompt_payload || {})
        adapter = SolidAgents.runtime_adapter(run.runtime)
        result = adapter.execute(run: run, prompt: prompt)

        run.artifacts.create!(kind: "log", label: "runtime_output", storage_type: "inline", content_text: result.output.to_s)

        if result.ok
          metadata = result.metadata.to_h
          run.update!(status: :succeeded, finished_at: Time.current, result_payload: {output: result.output, metadata: metadata})
          run.append_event!("runtime_succeeded", message: "Runtime execution finished", payload: metadata)
        else
          run.update!(status: :failed, finished_at: Time.current, error_payload: {stderr: result.error, metadata: result.metadata})
          run.append_event!("runtime_failed", message: "Runtime execution failed", payload: result.metadata.to_h.merge("stderr" => result.error.to_s))
        end

        run
      end
    end
  end
end
