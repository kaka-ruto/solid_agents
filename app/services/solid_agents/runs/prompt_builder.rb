# frozen_string_literal: true

require "json"

module SolidAgents
  module Runs
    class PromptBuilder
      def self.call(run:, context:)
        <<~PROMPT
          Stage owner: #{run.stage_owner}
          Stage: #{run.stage}
          Run id: #{run.id}

          Constraints:
          - Repository path: #{run.repo_path}
          - Base branch: #{run.base_branch}
          - Test command: #{run.test_command}
          - Runtime: #{run.runtime}
          - Max iterations: #{run.max_iterations || SolidAgents.max_iterations}

          Context JSON:
          #{JSON.pretty_generate(context)}
        PROMPT
      end
    end
  end
end
