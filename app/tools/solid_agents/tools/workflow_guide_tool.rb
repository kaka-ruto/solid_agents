# frozen_string_literal: true

module SolidAgents
  module Tools
    class WorkflowGuideTool < RubyLLM::Tool
      description "Returns workflow guidance for a given stage owner pair"

      param :stage, type: "string", desc: "Current workflow stage"
      param :owner, type: "string", desc: "Current stage owner"

      def execute(stage:, owner:)
        {
          stage: stage,
          owner: owner,
          guidance: "Produce concise evidence, then hand off cleanly to the next stage owner.",
          required_outputs: ["notes", "artifacts", "handoff_summary"]
        }
      end
    end
  end
end
