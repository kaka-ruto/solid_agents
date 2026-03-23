# frozen_string_literal: true

module SolidAgents
  module Runs
    class Executor
      def self.call(run)
        stage = run.stage
        owner = SolidAgents::Workflow.stage_agent(stage)

        run.start_stage!(actor: owner)

        prompt = PromptBuilder.call(run: run, context: run.prompt_payload || {})
        adapter = SolidAgents.runtime_adapter(run.runtime)
        result = adapter.execute(run: run, prompt: prompt)

        run.artifacts.create!(
          kind: "log",
          label: "#{stage}_runtime_output",
          storage_type: "inline",
          content_text: result.output.to_s,
          content_json: {"metadata" => result.metadata.to_h}
        )

        unless result.ok
          run.fail!(error_payload: {"stage" => stage, "stderr" => result.error.to_s, "metadata" => result.metadata.to_h}, actor: owner)
          return run
        end

        next_stage = SolidAgents::Workflow.next_stage(stage)
        next_owner = SolidAgents::Workflow.stage_agent(next_stage)

        run.handoffs.create!(
          stage: stage,
          from_agent: owner,
          to_agent: next_owner,
          note: "#{owner} completed #{stage} and handed off to #{next_owner}",
          payload: {"output_excerpt" => result.output.to_s.slice(0, 500)}
        )

        run.append_event!(
          "stage_completed",
          message: "#{owner} completed #{stage}",
          payload: {"stage" => stage, "next_stage" => next_stage, "next_owner" => next_owner},
          actor: owner
        )

        if next_stage == "done"
          run.complete!(result_payload: {"final_stage" => stage, "metadata" => result.metadata.to_h, "output" => result.output.to_s}, actor: next_owner)
        else
          run.transition_to!(next_stage, actor: owner, message: "Transitioned from #{stage} to #{next_stage}", payload: {"next_owner" => next_owner})
          SolidAgents::ExecuteRunJob.perform_later(run.id)
        end

        run
      rescue StandardError => e
        run.fail!(error_payload: {"stage" => run.stage, "exception" => e.class.name, "message" => e.message}, actor: SolidAgents::Workflow.stage_agent(run.stage))
        run
      end
    end
  end
end
