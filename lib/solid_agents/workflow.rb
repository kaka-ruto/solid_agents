# frozen_string_literal: true

module SolidAgents
  module Workflow
    STAGES = [
      "received",
      "triaged",
      "repro_test",
      "repro_manual",
      "fixing",
      "verifying",
      "pr_opened",
      "ci_wait",
      "done"
    ].freeze

    STAGE_TO_AGENT = {
      "received" => "alex",
      "triaged" => "alex",
      "repro_test" => "betty",
      "repro_manual" => "betty",
      "fixing" => "chad",
      "verifying" => "david",
      "pr_opened" => "emma",
      "ci_wait" => "emma",
      "done" => "emma"
    }.freeze

    FINAL_STAGES = ["done", "failed"].freeze

    module_function

    def next_stage(current_stage)
      index = STAGES.index(current_stage)
      return "done" if index.nil? || index == STAGES.length - 1

      STAGES[index + 1]
    end

    def stage_agent(stage)
      STAGE_TO_AGENT.fetch(stage.to_s, "alex")
    end

    def final_stage?(stage)
      FINAL_STAGES.include?(stage.to_s)
    end
  end
end
