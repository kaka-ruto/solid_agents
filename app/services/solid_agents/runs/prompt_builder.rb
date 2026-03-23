# frozen_string_literal: true

require "json"

module SolidAgents
  module Runs
    class PromptBuilder
      def self.call(run:, context:)
        <<~PROMPT
          You are #{run.stage_owner} executing stage #{run.stage} for run #{run.id}.
          Goal: move the workflow to the next stage with clear evidence.

          Constraints:
          - Repository path: #{run.repo_path}
          - Base branch: #{run.base_branch}
          - Test command: #{run.test_command}
          - Runtime: #{run.runtime}
          - Max iterations: #{run.max_iterations || SolidAgents.max_iterations}

          Stage handoff contract:
          - Produce concise notes for the next stage owner.
          - Include reproducible evidence and command output.
          - Respect repository rules from AGENTS.md.

          Context JSON:
          #{JSON.pretty_generate(context)}
        PROMPT
      end
    end
  end
end
